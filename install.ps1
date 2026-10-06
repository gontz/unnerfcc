#!/usr/bin/env pwsh
#Requires -Version 7.0
#
# install.ps1 — patch your Claude Code binary with the un-nerfed prompts.
#               PowerShell port of install.sh (Windows). STANDALONE: uses
#               unnerfcc's OWN toolkit in engine/ (bun-binary, patch-prompts) —
#               no dependency on the tweakcc-fixed project.
#
# WHAT IT DOES
#   1. Picks the CC version to patch — the newest version we have a prompt catalog
#      for (data/prompts/), unless --version pins one. Works whether or not CC is
#      installed: it installs (or switches to) that version via npm as needed, and
#      an already-installed *supported* version is used as-is. If CC's latest npm
#      release is newer than any catalog we have, it says so (run .\upgrade.ps1 to
#      add support) and targets the newest version it CAN patch.
#   2. Rebuilds that version's STOCK prompts from the catalog and replays the
#      un-nerfs (sync-version.mjs + apply-unnerfs.py) into system-prompts/.
#   3. Unpacks the binary's JS bundle, splices the un-nerfed prompts in (vendored
#      patcher), applies the best-effort effort un-nerfs, repacks, and BOOT-CHECKS
#      the result. No backup is taken: the patched binary is swapped in only after
#      a clean boot-check, and any earlier failure leaves the installed binary
#      untouched. To roll back, reinstall Claude Code.
#   4. Verifies the un-nerf sentinels actually landed, and disables CC's
#      auto-updater so the patch isn't silently reverted on next launch.
#
# If Bun changed the binary format, engine/bun-binary.mjs reports it and this
# script STOPS — update engine/bun-binary.mjs for the new layout.
#
# USAGE
#   .\install.ps1 [--dry-run] [--version X.Y.Z] [--help]
#     --version X.Y.Z  pin an exact CC release (must have a catalog); default is
#                      the newest catalog we ship.
#
#   Run it from PowerShell 7 (`pwsh`):  pwsh -NoProfile -File .\install.ps1
#
# WINDOWS NOTES (what differs from install.sh, and why)
#   * The target is the native PE at bin\claude.exe. npm's global `claude` entry
#     is a .cmd/.ps1 SHIM, not the binary, so it is resolved through to
#     <npm prefix>\node_modules\@anthropic-ai\claude-code\bin\claude.exe; the
#     native installer's %USERPROFILE%\.local\bin\claude.exe is used directly.
#   * No chmod/`stat -c` — NTFS carries ACLs, not POSIX mode bits. The swap uses
#     [IO.File]::Replace, which is atomic and keeps the target's ACL.
#   * `python3` is not the Windows command name; the interpreter is resolved by
#     probing what actually runs (see Resolve-Python).
#   * A running Claude Code process locks its own exe, so the final swap fails
#     loudly instead of half-writing it. Close your sessions first.

$ErrorActionPreference = 'Stop'
Set-StrictMode -Off
Set-Location $PSScriptRoot

$REPO        = $PSScriptRoot
$NATIVE_CLI  = Join-Path $REPO 'engine\bun-binary.mjs'
$PATCH_CLI   = Join-Path $REPO 'engine\patch-prompts.mjs'
$ENGINE_DIR  = Join-Path $REPO 'engine'
$SCRIPTS_DIR = Join-Path $REPO 'scripts'
$PROMPTS_DIR = Join-Path $REPO 'data\prompts'
$SYS_PROMPTS = Join-Path $REPO 'system-prompts'

# --- output helpers ----------------------------------------------------------
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}
function Log($m)  { Write-Host "==> $m" -ForegroundColor Cyan }
function Info($m) { Write-Host "    $m" }
function Ok($m)   { Write-Host "  ✓ $m" -ForegroundColor Green }
function Warn($m) { [Console]::Error.WriteLine("  !! $m") }
function Die($m)  { [Console]::Error.WriteLine("ERROR: $m"); exit 1 }

$Usage = @'
USAGE
  .\install.ps1 [--dry-run] [--version X.Y.Z] [--help]
    --dry-run        print the commands instead of running them
    --version X.Y.Z  pin an exact CC release (must have a catalog)
    --help           this text

  pwsh -NoProfile -File .\install.ps1
'@

# --- args --------------------------------------------------------------------
$DRY_RUN = $false; $WANT_VERSION = ''
for ($i = 0; $i -lt $args.Count; $i++) {
  switch ($args[$i]) {
    '--dry-run' { $DRY_RUN = $true }
    '--version' { $i++; if ($i -ge $args.Count) { Die '--version needs a value' }; $WANT_VERSION = $args[$i] }
    { $_ -in '-h', '--help' } { Write-Host $Usage; exit 0 }
    default { [Console]::Error.WriteLine("unknown arg: $($args[$i])"); exit 2 }
  }
}

# --- native command helpers --------------------------------------------------
# Runs a native command, merging stderr into stdout the way `$(cmd 2>&1)` does,
# and returns its exit code. $ErrorActionPreference is relaxed for the duration:
# under 'Stop', PowerShell turns a native command's stderr into a terminating
# ErrorRecord, which would abort us on any tool that logs to stderr.
function Invoke-Native {
  param([Parameter(Mandatory)][string]$Exe, [string[]]$Arguments = @())
  $prev = $ErrorActionPreference
  $ErrorActionPreference = 'Continue'
  try {
    $out = & $Exe @Arguments 2>&1 | Out-String
    $rc = $LASTEXITCODE
  } finally { $ErrorActionPreference = $prev }
  $text = ($out -replace "`r`n", "`n").TrimEnd("`n", ' ')
  return [pscustomobject]@{ Rc = $rc; Out = $text }
}

# Same, but streams line by line (prefixed) so a multi-minute AI step stays
# observable instead of dumping everything at the end.
function Invoke-Streamed {
  param([Parameter(Mandatory)][string]$Exe, [string[]]$Arguments = @(), [string]$Indent = '    ')
  $prev = $ErrorActionPreference
  $ErrorActionPreference = 'Continue'
  try {
    & $Exe @Arguments 2>&1 | ForEach-Object { Write-Host "$Indent$_" }
    $rc = $LASTEXITCODE
  } finally { $ErrorActionPreference = $prev }
  return $rc
}

# Dry-run wrapper: print, don't run. Mirrors install.sh's run().
function Invoke-Step {
  param([Parameter(Mandatory)][string]$Display, [Parameter(Mandatory)][scriptblock]$Block)
  if ($DRY_RUN) { Write-Host "[dry-run] $Display" -ForegroundColor Magenta } else { & $Block | Out-Null }
}

# True if $1 is a binary we have already patched. The un-nerf sentinels are plain
# text in the module blob, so a raw byte search of the executable finds them; no
# stock build contains any of them. node does the search because it is already a
# hard precondition and Buffer.includes is a native scan — Select-String would
# read a 250 MB PE as one giant "line".
$script:SentinelBinaryJs = 'const b=require("fs").readFileSync(process.argv[1]);for(const n of process.argv.slice(2))if(b.includes(n))process.exit(0);process.exit(1)'
$script:SentinelDirJs    = 'const fs=require("fs"),p=require("path");let hit=false;const walk=d=>{for(const e of fs.readdirSync(d,{withFileTypes:true})){if(hit)return;const f=p.join(d,e.name);if(e.isDirectory())walk(f);else if(fs.readFileSync(f).includes(process.argv[2]))hit=true}};walk(process.argv[1]);process.exit(hit?0:1)'

function Test-Unnerfed([string]$Path) {
  $r = Invoke-Native 'node' @('-e', $script:SentinelBinaryJs, $Path,
    'senior-engineer standard',
    'never trade away rigor, depth, or correctness',
    'thorough, clear, and rich with explanation')
  return $r.Rc -eq 0
}

function Stop-BunIncompatible($detail) {
  [Console]::Error.WriteLine('')
  [Console]::Error.WriteLine('BUN FORMAT INCOMPATIBLE — engine/bun-binary.mjs could not parse this')
  [Console]::Error.WriteLine('Claude Code binary. Bun likely changed its standalone container format.')
  [Console]::Error.WriteLine('Update the format logic in engine/bun-binary.mjs for the new layout.')
  [Console]::Error.WriteLine("detail: $detail")
  exit 3
}

# --- version helpers ---------------------------------------------------------
function Read-ClaudeVersion([string]$ExePath) {
  $r = Invoke-Native $ExePath @('--version')
  $m = [regex]::Match($r.Out, '\d+\.\d+\.\d+')
  if ($m.Success) { return $m.Value }
  return ''
}

# `sort -V | tail -1` for a list of X.Y.Z strings.
function Select-NewestVersion([string[]]$Versions) {
  $parsed = foreach ($v in $Versions) {
    $ver = $null
    if ([version]::TryParse($v, [ref]$ver)) { [pscustomobject]@{ V = $ver; S = $v } }
  }
  $top = @($parsed) | Sort-Object V | Select-Object -Last 1
  if ($top) { return $top.S }
  return ''
}

# --- preconditions -----------------------------------------------------------
if (-not (Get-Command node -ErrorAction SilentlyContinue)) { Die 'node not found' }
if (-not (Get-Command npm  -ErrorAction SilentlyContinue)) { Warn 'npm not found — cannot install or switch Claude Code versions' }

# `python3` is not how Windows names the interpreter, and a name that resolves to
# the Microsoft Store stub exits without running anything. Probe by execution.
function Resolve-Python {
  $order = if ($IsWindows) { 'python', 'python3', 'py' } else { 'python3', 'python' }
  foreach ($c in $order) {
    $g = Get-Command $c -ErrorAction SilentlyContinue
    if (-not $g) { continue }
    $r = Invoke-Native $g.Source @('-c', 'import sys;sys.stdout.write("1")')
    if ($r.Rc -eq 0 -and $r.Out.Trim() -eq '1') { return $g.Source }
  }
  return $null
}
$PYTHON = Resolve-Python
if (-not $PYTHON) { Die 'no working python interpreter found (tried python3, python, py)' }

# Install engine/ deps on first run (node-lief native addon, babel, prettier).
if (-not (Test-Path $NATIVE_CLI)) { Die 'engine/bun-binary.mjs missing — is the repo intact?' }
if (-not (Test-Path $PATCH_CLI))  { Die 'engine/patch-prompts.mjs missing — is the repo intact?' }
if (-not (Test-Path (Join-Path $ENGINE_DIR 'node_modules\node-lief'))) {
  Log 'Installing engine/ dependencies (first run: node-lief, @babel/parser, prettier)'
  Invoke-Step "( cd '$ENGINE_DIR' && npm install )" {
    Push-Location $ENGINE_DIR
    try { $rc = Invoke-Streamed 'npm' @('install', '--no-audit', '--no-fund') -Indent '    ' }
    finally { Pop-Location }
    if ($rc -ne 0) { Die "npm install in engine/ failed (exit $rc)" }
  }
}

# Install scripts/ deps on first run (gray-matter, used by sync-version.mjs).
if (-not (Test-Path (Join-Path $SCRIPTS_DIR 'node_modules\gray-matter'))) {
  Log 'Installing scripts/ dependencies (first run: gray-matter)'
  Invoke-Step "( cd '$SCRIPTS_DIR' && npm install --ignore-scripts --save-exact )" {
    Push-Location $SCRIPTS_DIR
    try { $rc = Invoke-Streamed 'npm' @('install', '--ignore-scripts', '--save-exact', '--no-audit', '--no-fund') -Indent '    ' }
    finally { Pop-Location }
    if ($rc -ne 0) { Die "npm install in scripts/ failed (exit $rc)" }
  }
}

# --- choose the CC version to target -----------------------------------------
# Works whether or not Claude Code is installed. We can only patch a version we
# have a prompt catalog for, so the default target is the newest such version;
# an already-installed *supported* version is respected as-is (no churn).
Log 'Resolving target Claude Code version'

# Newest version we have a catalog for (the newest we can patch). The anchored
# pattern also keeps the `.candidates.json` sidecars out of the list, which a
# looser glob would let masquerade as a version like "2.1.280.candidates".
$catalogVersions = @(
  Get-ChildItem $PROMPTS_DIR -Filter 'prompts-*.json' -File -ErrorAction SilentlyContinue |
    ForEach-Object { if ($_.Name -match '^prompts-(\d+\.\d+\.\d+)\.json$') { $Matches[1] } }
)
if ($catalogVersions.Count -eq 0) { Die "no prompt catalogs in $PROMPTS_DIR — is the repo intact?" }
$SUPPORTED_LATEST = Select-NewestVersion $catalogVersions

# Newest published CC (best-effort; network). Purely informational.
$NPM_LATEST = ''
if (Get-Command npm -ErrorAction SilentlyContinue) {
  $r = Invoke-Native 'npm' @('view', '@anthropic-ai/claude-code', 'version')
  if ($r.Rc -eq 0) { $NPM_LATEST = ($r.Out -split "`n" | Select-Object -Last 1).Trim() }
}

# Currently-installed CC version, if any.
$INSTALLED_VERSION = ''
$claudeCmd = Get-Command claude -ErrorAction SilentlyContinue
if ($claudeCmd) { $INSTALLED_VERSION = Read-ClaudeVersion $claudeCmd.Source }

# Target: explicit --version wins; else keep a supported installed version; else
# fall back to the newest version we can patch.
if ($WANT_VERSION) {
  $CC_VERSION = $WANT_VERSION
} elseif ($INSTALLED_VERSION -and (Test-Path (Join-Path $PROMPTS_DIR "prompts-$INSTALLED_VERSION.json"))) {
  $CC_VERSION = $INSTALLED_VERSION
} else {
  $CC_VERSION = $SUPPORTED_LATEST
}

$CATALOG = Join-Path $PROMPTS_DIR "prompts-$CC_VERSION.json"
if (-not (Test-Path $CATALOG)) {
  Die @"
no prompt catalog for v$CC_VERSION at $CATALOG.
    We have catalogs up to v$SUPPORTED_LATEST. Run  .\upgrade.ps1  against a v$CC_VERSION
    binary to generate it, or pass --version <a supported release>.
"@
}

# Report the gap between what CC ships and what we can patch.
if ($NPM_LATEST -and $NPM_LATEST -ne $SUPPORTED_LATEST) {
  $newest = Select-NewestVersion @($NPM_LATEST, $SUPPORTED_LATEST)
  if ($newest -eq $NPM_LATEST) {
    Warn "Claude Code latest is v$NPM_LATEST; unnerfcc has prompts only up to v$SUPPORTED_LATEST → targeting v$CC_VERSION."
    Warn "  To support v$NPM_LATEST, run .\upgrade.ps1 against it first."
  }
}
Ok "target version: v$CC_VERSION (catalog: $CATALOG)"

# --- npm global bin + the Windows shim ---------------------------------------
# npm's global entry for claude on Windows is a .cmd/.ps1 SHIM in the prefix dir
# (the prefix IS the bin dir — there is no /bin like on Unix). The real PE lives
# under the package it points at. The native installer instead drops claude.exe
# straight into %USERPROFILE%\.local\bin, which needs no resolution.
function Get-NpmGlobalBin {
  if (-not (Get-Command npm -ErrorAction SilentlyContinue)) { return $null }
  $r = Invoke-Native 'npm' @('config', 'get', 'prefix')
  if ($r.Rc -ne 0) { return $null }
  $prefix = ($r.Out -split "`n" | Select-Object -Last 1).Trim()
  if (-not $prefix) { return $null }
  if (Test-Path (Join-Path $prefix 'node_modules')) { return $prefix }
  return (Join-Path $prefix 'bin')
}

function Resolve-ClaudeBinary([string]$Launcher) {
  $p = $Launcher
  # Follow a reparse point (symlink/junction) if there is one — readlink -f.
  for ($hop = 0; $hop -lt 8; $hop++) {
    $item = Get-Item $p -Force -ErrorAction SilentlyContinue
    if (-not $item) { break }
    $target = $item.Target
    if (-not $target) { break }
    if ($target -is [array]) { $target = $target[0] }
    # Get-Item reports a reparse target with the native "\??\" prefix some
    # providers use; IsPathRooted() reads it as relative and would corrupt it.
    if ($target.StartsWith('\??\')) { $target = $target.Substring(4) }
    if (-not [System.IO.Path]::IsPathRooted($target)) { $target = Join-Path (Split-Path $p -Parent) $target }
    $p = $target
  }
  # npm shim → the package's real exe. No-op when $p already is one.
  if ($p -notmatch '\.exe$') {
    $exe = Join-Path (Split-Path $p -Parent) 'node_modules\@anthropic-ai\claude-code\bin\claude.exe'
    if (Test-Path $exe) { return (Resolve-ClaudeBinary $exe) }
  }
  return $p
}

# --- ensure CC is installed at the target version ----------------------------
if ($INSTALLED_VERSION -ne $CC_VERSION) {
  if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Die "need Claude Code v$CC_VERSION but npm is unavailable to install it"
  }
  if ($INSTALLED_VERSION) {
    Log "Installed Claude Code is v$INSTALLED_VERSION — switching to v$CC_VERSION (the version unnerfcc patches)"
  } else {
    Log "Claude Code not found on PATH — installing v$CC_VERSION"
  }
  Invoke-Step "npm install -g @anthropic-ai/claude-code@$CC_VERSION" {
    $rc = Invoke-Streamed 'npm' @('install', '-g', "@anthropic-ai/claude-code@$CC_VERSION", '--no-audit', '--no-fund') -Indent '    '
    if ($rc -ne 0) { Die "npm install -g @anthropic-ai/claude-code@$CC_VERSION failed (exit $rc)" }
  }
  if (-not $DRY_RUN) {
    $claudeCmd = Get-Command claude -ErrorAction SilentlyContinue
    if (-not $claudeCmd) {
      $npmBin = Get-NpmGlobalBin
      if ($npmBin -and (Get-ChildItem $npmBin -Filter 'claude.*' -File -ErrorAction SilentlyContinue)) {
        $env:PATH = "$npmBin;$env:PATH"
        Warn "added npm global bin to PATH for this run: $npmBin (add it to your PATH to keep 'claude' available)"
        $claudeCmd = Get-Command claude -ErrorAction SilentlyContinue
      }
    }
    if (-not $claudeCmd) {
      Die "installed Claude Code but 'claude' is still not on PATH — add the npm global bin dir (npm config get prefix) to your PATH and re-run"
    }
  }
}

# --- resolve binary ----------------------------------------------------------
Log 'Resolving Claude Code binary'
if ($DRY_RUN -and -not $claudeCmd) {
  Ok "dry-run: would target v$CC_VERSION (binary not resolved — not installed)"
  $CC_BIN = $null
} elseif (-not $claudeCmd) {
  Die "'claude' is not on PATH — install Claude Code (npm install -g @anthropic-ai/claude-code) and re-run"
} else {
  $LAUNCHER = $claudeCmd.Source
  $CC_BIN = Resolve-ClaudeBinary $LAUNCHER
  if (-not (Test-Path $CC_BIN)) { Die "could not resolve the claude binary from $LAUNCHER" }
  $RESOLVED_VERSION = Read-ClaudeVersion $CC_BIN
  if ($RESOLVED_VERSION -ne $CC_VERSION) {
    Warn "resolved binary reports v$RESOLVED_VERSION but targeting v$CC_VERSION — a stale launcher may be shadowing it"
  }
  Ok "binary: $CC_BIN (v$CC_VERSION)"
  # Re-patching our own output is not a no-op: the un-nerfs have no stock anchor
  # left to match, so every one of them silently drops (patched=0), and the
  # repack has to re-locate a blob pointer whose value we ourselves chose.
  # Restore stock first; this is the same "reinstall stock CC before re-patching"
  # the splice step tells you to do by hand.
  if (-not $DRY_RUN -and (Test-Unnerfed $CC_BIN)) {
    if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
      Die "the installed v$CC_VERSION binary is already un-nerfed and npm is unavailable to restore a stock copy — reinstall Claude Code manually, then re-run"
    }
    Log "Installed binary is already un-nerfed — restoring stock v$CC_VERSION before re-patching"
    Invoke-Step "npm install -g @anthropic-ai/claude-code@$CC_VERSION" {
      $rc = Invoke-Streamed 'npm' @('install', '-g', "@anthropic-ai/claude-code@$CC_VERSION", '--no-audit', '--no-fund') -Indent '    '
      if ($rc -ne 0) { Die "npm install -g failed (exit $rc)" }
    }
    $LAUNCHER = (Get-Command claude -ErrorAction SilentlyContinue).Source
    $CC_BIN = Resolve-ClaudeBinary $LAUNCHER
    if (-not (Test-Path $CC_BIN)) { Die "could not resolve the claude binary from $LAUNCHER after restoring stock" }
    if (Test-Unnerfed $CC_BIN) { Die "restored v$CC_VERSION from npm but the binary still contains un-nerf sentinels — refusing to patch it twice" }
    Ok "restored stock binary: $CC_BIN"
  }
}

# --- rebuild stock + replay un-nerfs -----------------------------------------
Log 'Rebuilding stock prompts + replaying un-nerfs'
Invoke-Step "node scripts\sync-version.mjs $CC_VERSION" {
  $rc = Invoke-Streamed 'node' @((Join-Path $REPO 'scripts\sync-version.mjs'), $CC_VERSION)
  if ($rc -ne 0) { Die "sync-version.mjs failed (exit $rc)" }
}
Invoke-Step "python scripts\apply-unnerfs.py --quiet" {
  $rc = Invoke-Streamed $PYTHON @((Join-Path $REPO 'scripts\apply-unnerfs.py'), '--quiet')
  if ($rc -ne 0) { Die "apply-unnerfs.py failed (exit $rc)" }
}
Invoke-Step "python scripts\apply-unnerfs.py --check --quiet" {
  $rc = Invoke-Streamed $PYTHON @((Join-Path $REPO 'scripts\apply-unnerfs.py'), '--check', '--quiet')
  if ($rc -ne 0) { Die 'apply-unnerfs --check not clean' }
}
Ok 'un-nerfed .md set ready in system-prompts/'

if ($DRY_RUN) { Log '[dry-run] would unpack, patch, repack, boot-check, verify, install'; exit 0 }

# --- workspace ---------------------------------------------------------------
# No backup: the patched binary is only swapped in AFTER a successful boot-check,
# and any earlier failure exits without touching the installed binary. To restore
# stock, reinstall Claude Code (see the rollback note at the end).
$WORK = Join-Path $env:TEMP "unnerfcc-install-$([guid]::NewGuid().ToString('N').Substring(0, 8))"
New-Item -ItemType Directory -Path $WORK -Force | Out-Null

try {
  # --- unpack -> patch -> repack ---------------------------------------------
  # CLI_JS/PATCHED_JS are directories (one file per Bun module) since v2.1.251's
  # multi-module build; see engine/bun-binary.mjs unpackToDir/repackFromDir.
  $CLI_JS     = Join-Path $WORK 'cli-js'
  $PATCHED_JS = Join-Path $WORK 'patched-js'
  $PATCHED_BIN = Join-Path $WORK 'claude.patched.exe'

  Log 'Unpacking JS bundle'
  $u = Invoke-Native 'node' @($NATIVE_CLI, 'unpack', $CC_BIN, $CLI_JS)
  if ($u.Out -match 'BUN_FORMAT_INCOMPATIBLE' -or $u.Rc -eq 3) { Stop-BunIncompatible $u.Out }
  if ($u.Rc -ne 0) { Die "unpack failed: $($u.Out)" }
  # Total size comes from unpack's own "bytes=<n>" stdout line, not a file size,
  # since CLI_JS is now a directory of many module files.
  $UNPACK_BYTES = 0
  if ($u.Out -match 'bytes=(\d+)') { $UNPACK_BYTES = [int]$Matches[1] }
  Ok ('unpacked {0:N1}MB' -f ($UNPACK_BYTES / 1MB))

  Log 'Splicing un-nerfed prompts into the bundle'
  # Exit codes: 0 ok · 2 output is invalid JS (must NOT repack) · 3 a real un-nerf
  # failed to splice (output is valid, just missing that one — ship the rest, warn
  # loudly) · anything else is a crash.
  $s = Invoke-Native 'node' @($PATCH_CLI, 'apply', $CLI_JS, $CATALOG, $SYS_PROMPTS, $PATCHED_JS)
  ($s.Out -split "`n") | ForEach-Object { Write-Host "    $_" }
  switch ($s.Rc) {
    0 { }
    3 { Warn 'one or more un-nerfs did NOT reach the binary (see [LOST] above) — shipping the remaining un-nerfs; fix the catalog pieces/rule anchor and re-run' }
    default { Die "prompt splice failed (exit $($_)) — see output above" }
  }

  # --- effort un-nerfs (BEST-EFFORT; must never block the prompt patches) -----
  # Lift CC's silent effort caps (mid-tier model default, /effort capped below the
  # ceiling). Runs on the already-prompt-patched bundle; if an anchor drifted, it
  # reports and we ship the prompt un-nerfs alone. See engine/apply-code-patches.mjs.
  $EFF_JS = Join-Path $WORK 'patched-effort-js'
  Log 'Applying effort un-nerfs (best-effort)'
  # 3 dirs, not 2: apply-code-patches.mjs runs downstream of patch-prompts.mjs's
  # SPARSE output (only the modules it changed), so it needs the pristine unpack
  # (CLI_JS) to search across every module for the effort-config code, plus that
  # sparse output (PATCHED_JS) to know what's already changed.
  $e = Invoke-Native 'node' @((Join-Path $REPO 'engine\apply-code-patches.mjs'), 'apply', $CLI_JS, $PATCHED_JS, $EFF_JS)
  ($e.Out -split "`n") | ForEach-Object { Write-Host "    $_" }
  if (Test-Path $EFF_JS) {
    $PATCHED_JS = $EFF_JS   # ship prompt + effort un-nerfs
    if ($e.Out -match 'SOME MISSING') {
      Warn "effort un-nerf incomplete — CC's effort code likely changed; prompt un-nerfs are unaffected"
    }
  } else {
    Warn 'effort un-nerf pass produced no output — shipping prompt un-nerfs only (binary unaffected)'
  }

  Log 'Repacking + boot-check'
  $rp = Invoke-Native 'node' @($NATIVE_CLI, 'repack', $CC_BIN, $PATCHED_JS, $PATCHED_BIN)
  if ($rp.Out -match 'BUN_FORMAT_INCOMPATIBLE' -or $rp.Rc -ne 0) { Die "repack failed: $($rp.Out)" }
  $boot = Invoke-Native $PATCHED_BIN @('--version')
  if ($boot.Rc -ne 0) { Die "patched binary failed boot-check — NOT installing; your binary is untouched" }
  Ok 'patched binary boots'

  # --- sentinel verify (against the patched artifact, before install) --------
  $MISS = 0
  foreach ($sent in 'senior-engineer standard',
                    'never trade away rigor, depth, or correctness',
                    'Spawn agents whenever parallel investigation',
                    'investigate thoroughly, then be direct',
                    'thorough, clear, and rich with explanation') {
    $chk = Invoke-Native 'node' @('-e', $script:SentinelDirJs, $PATCHED_JS, $sent)
    if ($chk.Rc -ne 0) { Warn "sentinel missing: $sent"; $MISS++ }
  }
  if ($MISS -eq 0) { Ok 'all 5 un-nerf sentinels present' }
  else { Warn "$MISS sentinel(s) missing — patch may be partial for v$CC_VERSION (continuing; the binary boots)" }

  # --- install (atomic replace) ----------------------------------------------
  # [IO.File]::Replace swaps in one step and keeps the destination's ACL, which is
  # the Windows analogue of the bash version's rename-to-a-new-inode. A running
  # Claude Code holds its own exe open, so a sharing violation here is the common
  # failure and gets a specific message rather than a generic IO error.
  Log 'Installing patched binary'
  $tmp  = "$CC_BIN.unnerf.tmp"
  $bakk = "$CC_BIN.unnerf.backup"
  Copy-Item $PATCHED_BIN $tmp -Force
  try {
    # Replace needs a real backup name — a null one throws "The path is empty" on
    # .NET. It is a rename of the outgoing binary, not a copy, so it costs no disk
    # space, and it is what makes the swap atomic.
    [System.IO.File]::Replace($tmp, $CC_BIN, $bakk)
  } catch {
    Remove-Item $tmp -Force -ErrorAction SilentlyContinue
    Die "could not swap in the patched binary: $($_.Exception.Message)`n    If Claude Code is running, close every session (and any terminal using it) and re-run — Windows locks a running exe."
  }
  Remove-Item $bakk -Force -ErrorAction SilentlyContinue
  Ok "installed → $CC_BIN"
} finally {
  Remove-Item $WORK -Recurse -Force -ErrorAction SilentlyContinue
}

# --- disable CC auto-updater so the patch survives ---------------------------
Log 'Disabling Claude Code auto-updater (so the patch is not reverted on next launch)'
$SETTINGS = Join-Path $env:USERPROFILE '.claude\settings.json'
New-Item -ItemType Directory -Path (Split-Path $SETTINGS -Parent) -Force | Out-Null
$settingsJs = @'
  const fs=require("fs"),p=process.argv[1];let raw=null;
  try{raw=fs.readFileSync(p,"utf8")}catch(e){if(e.code!=="ENOENT")process.exit(3)}
  let j={};if(raw&&raw.trim()){try{j=JSON.parse(raw)}catch(e){process.exit(3)}}
  if(typeof j!=="object"||!j||Array.isArray(j))process.exit(3);
  if(j.env&&j.env.DISABLE_AUTOUPDATER==="1")process.exit(2);
  j.env=j.env||{};j.env.DISABLE_AUTOUPDATER="1";
  fs.writeFileSync(p,JSON.stringify(j,null,2)+"\n");
'@
$rc = (Invoke-Native 'node' @('-e', $settingsJs, $SETTINGS)).Rc
switch ($rc) {
  0 { Ok "DISABLE_AUTOUPDATER=1 set in $SETTINGS" }
  2 { Ok 'auto-updater already disabled' }
  default { Warn "could not update $SETTINGS — set env.DISABLE_AUTOUPDATER=1 yourself, or CC will auto-update and revert the patch" }
}

Log 'Done — restart any running Claude Code sessions.'
Info "Rollback: reinstall Claude Code (npm install -g @anthropic-ai/claude-code@$CC_VERSION). No backup is kept after install."
