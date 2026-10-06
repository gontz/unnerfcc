#!/usr/bin/env pwsh
#Requires -Version 7.0
#
# upgrade.ps1 — bring unnerfcc up to a new Claude Code release, fully standalone.
#               PowerShell port of upgrade.sh (Windows).
#
# This is the MAINTAINER flow (install.ps1 is the end-user apply flow). It:
#   1. resolves the TARGET version — the newest CC available on npm (or --version),
#      NOT whatever is installed — and fetches that exact binary into a temp
#      prefix if needed, so it runs whether or not CC is installed and never
#      touches your global install,
#   2. unpacks the CC native binary to its JS bundle          (vendored native I/O),
#   3. extracts a fresh prompt catalog, seeded with our previous one
#      so unchanged/reworded prompts keep their ids           (vendored extractor),
#   4. SHA-256-diffs new vs previous to find the relabel worklist,
#   5. **launches Claude Code headless to semantically label** the new/changed
#      fragments the extractor couldn't identify,
#   6. validates the catalog (structural gates),
#   7. reconstructs the stock .md set + replays the un-nerfs  (existing scripts),
#   8. verifies the un-nerfs still apply to the binary        (vendored patcher),
#   9. leaves everything staged for you to review + commit.
#
# It does NOT depend on the tweakcc-fixed project: extract/re-package the binary
# (engine/bun-binary.mjs), un-minify (engine/beautify.mjs), extract the catalog
# (engine/extract-prompts.mjs), and patch (engine/patch-prompts.mjs) are all OUR OWN
# code. The AI steps (classify, relabel, bucket-analyze) run on Gemini by
# default and on the `claude` CLI with LLM_PROVIDER=claude — see LLM_PROVIDER below.
#
# BUN FORMAT: if engine/bun-binary.mjs reports the binary's Bun container format is
# one it doesn't understand, this script STOPS — update engine/bun-binary.mjs for
# the new layout.
#
# USAGE
#   .\upgrade.ps1 [--version X.Y.Z] [--force] [--no-patch-verify] [--benchmark[=N]] [--yes]
#
# LLM_PROVIDER=gemini|claude  which model runs classify/relabel/bucket-analyze
#   (default gemini; needs GOOGLE_GEMINI_API_KEY in the environment, .\.env, or
#   ~\.env). GEMINI_MODEL overrides the model id (default gemini-3.7-flash).
#
# --benchmark[=N]: after a clean upgrade, run the SWE-bench harness on the STOCK
#   and just-PATCHED binaries and update the accuracy bar chart in README.md
#   (default N=10). OPT-IN and HEAVY: needs Docker + ~50GB disk + hours; it is
#   best-effort and never fails the upgrade. See scripts/benchmark.mjs — note it
#   shells out to bash + Docker and is Linux-only; on Windows it reports skipped.
#
# WINDOWS NOTES (what differs from upgrade.sh, and why)
#   * npm's global `claude` entry is a .cmd/.ps1 SHIM, not the native PE, so it is
#     resolved through to <dir>\node_modules\@anthropic-ai\claude-code\bin\claude.exe
#     before anything unpacks it. Unpacking a shim would fail obscurely.
#   * `python3` is not the Windows command name; the interpreter is resolved by
#     probing what actually runs (scripts/*.mjs do the same on win32).
#   * The work dir is preserved on failure exactly as the bash `trap` does — it
#     holds hours of model output that cannot be regenerated cheaply.
#   * Files written for the scripts to read are UTF-8 without a BOM; a BOM makes
#     JSON.parse reject them.

$ErrorActionPreference = 'Stop'
Set-StrictMode -Off
Set-Location $PSScriptRoot

$REPO        = $PSScriptRoot
$NATIVE_CLI  = Join-Path $REPO 'engine\bun-binary.mjs'
$PATCH_CLI   = Join-Path $REPO 'engine\patch-prompts.mjs'
$BUCKET_ANALYZE = Join-Path $REPO 'scripts\bucket-analyze.mjs'
$ENGINE_DIR  = Join-Path $REPO 'engine'
$SCRIPTS_DIR = Join-Path $REPO 'scripts'
$PROMPTS_DIR = Join-Path $REPO 'data\prompts'
$SYS_PROMPTS = Join-Path $REPO 'system-prompts'

try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}
function Log($m)  { Write-Host "==> $m" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "  ✓ $m" -ForegroundColor Green }
function Warn($m) { [Console]::Error.WriteLine("  ! $m") }
function Die($m)  { [Console]::Error.WriteLine("upgrade.ps1: $m"); exit 1 }

$Usage = @'
USAGE
  .\upgrade.ps1 [--version X.Y.Z] [--force] [--no-patch-verify] [--benchmark[=N]] [--yes]
    --version X.Y.Z      target this release instead of the newest on npm
    --force              regenerate the catalog even if the target is supported
    --no-patch-verify    skip the splice + repack + boot-check step
    --benchmark[=N]      after a clean upgrade, run the SWE-bench comparison
    --yes, -y            never prompt (auto-confirms the large classification job)
    --help               this text

  LLM_PROVIDER=gemini|claude   which model runs classify/relabel/bucket-analyze
  GEMINI_MODEL, CLASSIFY_BATCH, RELABEL_MODEL, ACK_REMOVED are read from the env.

  pwsh -NoProfile -File .\upgrade.ps1
'@

# --- args --------------------------------------------------------------------
$FORCE = $false; $PATCH_VERIFY = $true; $ASSUME_YES = $false
$WANT_VERSION = ''; $BENCHMARK = $false; $BENCH_N = 10
for ($i = 0; $i -lt $args.Count; $i++) {
  $a = $args[$i]
  if ($a -like '--benchmark=*') { $BENCHMARK = $true; $BENCH_N = $a.Split('=')[1]; continue }
  switch ($a) {
    '--version'        { $i++; if ($i -ge $args.Count) { Die '--version needs a value' }; $WANT_VERSION = $args[$i] }
    '--force'          { $FORCE = $true }
    '--no-patch-verify'{ $PATCH_VERIFY = $false }
    '--benchmark'      { $BENCHMARK = $true }
    { $_ -in '--yes', '-y' } { $ASSUME_YES = $true }
    { $_ -in '-h', '--help' } { Write-Host $Usage; exit 0 }
    default            { [Console]::Error.WriteLine("unknown arg: $a"); exit 2 }
  }
}

# --- native command helpers ---------------------------------------------------
# Runs a native command, merging stderr into stdout the way `$(cmd 2>&1)` does.
# $ErrorActionPreference is relaxed for the duration: under 'Stop', PowerShell
# turns a native command's stderr into a terminating ErrorRecord, which would
# abort us on any tool that merely logs to stderr.
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
# observable instead of dumping everything at the end. Returns the exit code.
function Invoke-Streamed {
  param([Parameter(Mandatory)][string]$Exe, [string[]]$Arguments = @(), [string]$Indent = '  ')
  $prev = $ErrorActionPreference
  $ErrorActionPreference = 'Continue'
  try {
    & $Exe @Arguments 2>&1 | ForEach-Object { Write-Host "$Indent$_" }
    $rc = $LASTEXITCODE
  } finally { $ErrorActionPreference = $prev }
  return $rc
}

function Show-Indented([string]$Text, [string]$Indent = '  ') {
  foreach ($line in ($Text -split "`n")) { Write-Host "$Indent$line" }
}

function Stop-BunIncompatible($detail) {
  [Console]::Error.WriteLine('')
  [Console]::Error.WriteLine('╔══════════════════════════════════════════════════════════════╗')
  [Console]::Error.WriteLine('║  BUN FORMAT INCOMPATIBLE — engine/bun-binary.mjs could not parse ║')
  [Console]::Error.WriteLine('║  this Claude Code binary. Bun likely changed its standalone   ║')
  [Console]::Error.WriteLine('║  container format. Update the format constants/logic in       ║')
  [Console]::Error.WriteLine('║  engine/bun-binary.mjs for the new layout (its header documents ║')
  [Console]::Error.WriteLine('║  the format; a current tweakcc-fixed is a useful reference).  ║')
  [Console]::Error.WriteLine('╚══════════════════════════════════════════════════════════════╝')
  [Console]::Error.WriteLine("detail: $detail")
  exit 3
}

# True if $1 is a binary this tool has already patched. The un-nerf sentinels are
# plain text in the module blob, so a raw byte search finds them; no stock build
# contains any of them. Used to refuse to unpack our own output. node does the
# scan because it is already a hard precondition and Buffer.includes is native —
# Select-String would read a 250 MB PE as one giant "line".
$script:SentinelBinaryJs = 'const b=require("fs").readFileSync(process.argv[1]);for(const n of process.argv.slice(2))if(b.includes(n))process.exit(0);process.exit(1)'
$script:SentinelDirJs    = 'const fs=require("fs"),p=require("path");let hit=false;const walk=d=>{for(const e of fs.readdirSync(d,{withFileTypes:true})){if(hit)return;const f=p.join(d,e.name);if(e.isDirectory())walk(f);else if(fs.readFileSync(f).includes(process.argv[2]))hit=true}};walk(process.argv[1]);process.exit(hit?0:1)'

function Test-Unnerfed([string]$Path) {
  $r = Invoke-Native 'node' @('-e', $script:SentinelBinaryJs, $Path,
    'senior-engineer standard',
    'never trade away rigor, depth, or correctness',
    'thorough, clear, and rich with explanation')
  return $r.Rc -eq 0
}

# Drops a labels/verdicts file that is short or malformed so the retry loop
# re-runs just that chunk. (Same node helper for both the relabel and the
# bucket-analysis loops.)
$script:DropShortLabelsJs = @'
const fs=require("fs");
const [c,l]=process.argv.slice(1);
if(!fs.existsSync(l)) process.exit(0);
try{
  const want=JSON.parse(fs.readFileSync(c,"utf8")).map(i=>i.ref).sort((a,b)=>a-b);
  const got=[...new Set(JSON.parse(fs.readFileSync(l,"utf8")).map(o=>o.ref))].sort((a,b)=>a-b);
  if(JSON.stringify(want)!==JSON.stringify(got)) fs.unlinkSync(l);
}catch{ fs.unlinkSync(l); }
'@

# --- version helpers ----------------------------------------------------------
function Read-ClaudeVersion([string]$ExePath) {
  $r = Invoke-Native $ExePath @('--version')
  $m = [regex]::Match($r.Out, '\d+\.\d+\.\d+')
  if ($m.Success) { return $m.Value }
  return ''
}

function Convert-ToVersion([string]$S) {
  $v = $null
  if ([version]::TryParse($S, [ref]$v)) { return $v }
  return [version]'0.0.0'
}

# `sort -V` for X.Y.Z strings.
function Sort-Versions([string[]]$Versions) {
  @($Versions | ForEach-Object { [pscustomobject]@{ V = (Convert-ToVersion $_); S = $_ } } |
    Sort-Object V | ForEach-Object { $_.S })
}

# --- preconditions ------------------------------------------------------------
if (-not (Get-Command node -ErrorAction SilentlyContinue)) { Die 'node not found' }

# NOTE: `claude` is NOT required to be installed — we fetch the target binary
# ourselves (see below). It's only used, if present, for the semantic relabel
# step; otherwise the freshly-fetched binary stands in.
if (-not (Test-Path $NATIVE_CLI)) { Die 'engine/bun-binary.mjs missing — is the repo intact?' }

# `python3` is not how Windows names the interpreter, and a name resolving to the
# Microsoft Store stub exits without running anything. Probe by execution.
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

# Check EVERY load-bearing dep, not just the first one ever added: a repo cloned
# (or last upgraded) before @babel/generator became required has a populated
# node_modules that a node-lief-only test would wrongly call complete, and the
# patcher would then die mid-run. @babel/generator is what writes the patched AST
# back out to source, so it is as load-bearing as the parser.
if (-not (Test-Path (Join-Path $ENGINE_DIR 'node_modules\node-lief')) -or
    -not (Test-Path (Join-Path $ENGINE_DIR 'node_modules\@babel\generator'))) {
  Log 'Installing engine/ dependencies (node-lief, @babel/parser, @babel/generator, prettier)'
  Push-Location $ENGINE_DIR
  try { $rc = Invoke-Streamed 'npm' @('install', '--no-audit', '--no-fund') '    ' } finally { Pop-Location }
  if ($rc -ne 0) { Die 'npm install in engine/ failed' }
}

# Install scripts/ deps too (gray-matter, used by sync-version.mjs at step 5) —
# a repo whose only prior run was install.ps1 (which bootstraps engine/ + scripts/)
# vs. one whose first run is upgrade.ps1 both need this; missing it here crashes
# step 5 with ERR_MODULE_NOT_FOUND after the (expensive, AI-driven) classify and
# relabel steps have already completed, which is the worst place to fail.
if (-not (Test-Path (Join-Path $SCRIPTS_DIR 'node_modules\gray-matter'))) {
  Log 'Installing scripts/ dependencies (first run: gray-matter)'
  Push-Location $SCRIPTS_DIR
  try { $rc = Invoke-Streamed 'npm' @('install', '--ignore-scripts', '--save-exact', '--no-audit', '--no-fund') '    ' }
  finally { Pop-Location }
  if ($rc -ne 0) { Die 'npm install in scripts/ failed' }
}

# Which model runs the three AI steps: classify, relabel, bucket-analyze. All
# three scripts speak both providers (scripts/llm-provider.mjs). gemini is the
# default because it is what this pipeline was measured on. LLM_PROVIDER=claude
# selects the agentic `claude -p` path instead.
#
# Both the name and the key are resolved among the preconditions, before the
# version probe and the ~100MB binary fetch below: the AI steps are separated by
# minutes of download and extraction, so a bad provider name or a missing key
# that only surfaced at relabel would waste all of it.
$LLM_PROVIDER = if ($env:LLM_PROVIDER) { $env:LLM_PROVIDER } else { 'gemini' }
if ($LLM_PROVIDER -notin @('claude', 'gemini')) {
  Die "LLM_PROVIDER must be 'claude' or 'gemini' (got: '$LLM_PROVIDER')"
}
$GEMINI_MODEL_RESOLVED = ''
if ($LLM_PROVIDER -eq 'gemini') {
  $llmProbe = 'import("./scripts/llm-provider.mjs").then(m=>{if(!m.findGeminiApiKey(process.cwd()))process.exit(1);console.log(m.DEFAULT_GEMINI_MODEL)}).catch(()=>process.exit(1))'
  $probe = Invoke-Native 'node' @('-e', $llmProbe)
  if ($probe.Rc -ne 0) {
    Die "LLM_PROVIDER=gemini but GOOGLE_GEMINI_API_KEY was not found — checked the environment, $REPO\.env, and ~\.env. Set it, or re-run with LLM_PROVIDER=claude."
  }
  $GEMINI_MODEL_RESOLVED = $probe.Out.Trim()
}

# --- resolve the TARGET version (works whether or not CC is installed) --------
# upgrade.ps1's job is to ADD un-nerf support for the newest Claude Code, so the
# target is the newest AVAILABLE release (npm) — not whatever happens to be
# installed — unless --version pins one. We fetch that exact version's binary
# ourselves below, so nothing needs to be installed first.
Log 'Resolving target Claude Code version'
New-Item -ItemType Directory -Path $PROMPTS_DIR -Force | Out-Null

# Newest COMPLETE catalog on disk, optionally excluding one version.
#
# A run that dies anywhere between gen-catalog (step 2) and the final repack
# (step 6) leaves a half-built prompts-<v>.json behind, and that file must not be
# mistaken for a finished one. gen-catalog is preceded by `touch
# prompts-<v>.json.incomplete` and the marker is removed only once step 6 has
# passed, so the marker's presence is exactly "this catalog is mid-build".
#
# `.candidates.json` sidecars live in the same dir and match the same glob, so
# they must be filtered out or the newest lookup can select one and yield a bogus
# SUPPORTED_LATEST like "2.1.219.candidates".
function Get-LatestCompleteCatalog([string]$Exclude = '') {
  $files = @(Get-ChildItem $PROMPTS_DIR -Filter 'prompts-*.json' -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -notmatch '\.candidates\.json$' })
  $candidates = foreach ($f in $files) {
    if (Test-Path "$($f.FullName).incomplete") { continue }
    if ($f.Name -notmatch '^prompts-(.+)\.json$') { continue }
    $v = $Matches[1]
    if ($Exclude -and $v -eq $Exclude) { continue }
    [pscustomobject]@{ V = (Convert-ToVersion $v); Path = $f.FullName }
  }
  $top = @($candidates | Sort-Object V | Select-Object -Last 1)
  if ($top) { return $top.Path }
  return ''
}

$PREV_CATALOG = Get-LatestCompleteCatalog
$SUPPORTED_LATEST = ''
if ($PREV_CATALOG) { $SUPPORTED_LATEST = [regex]::Match((Split-Path $PREV_CATALOG -Leaf), '^prompts-(.+)\.json$').Groups[1].Value }

# Newest published CC (best-effort; network).
$NPM_LATEST = ''
if (Get-Command npm -ErrorAction SilentlyContinue) {
  $r = Invoke-Native 'npm' @('view', '@anthropic-ai/claude-code', 'version')
  if ($r.Rc -eq 0) { $NPM_LATEST = ($r.Out -split "`n" | Select-Object -Last 1).Trim() }
}

# Currently-installed CC, if any (reused as-is when it already matches target).
$INSTALLED_VERSION = ''
$claudeCmd = Get-Command claude -ErrorAction SilentlyContinue
if ($claudeCmd) { $INSTALLED_VERSION = Read-ClaudeVersion $claudeCmd.Source }

# Target: --version wins; else the newest available on npm; else (offline) the
# installed version.
if ($WANT_VERSION) {
  $CC_VERSION = $WANT_VERSION
} elseif ($NPM_LATEST) {
  $CC_VERSION = $NPM_LATEST
} elseif ($INSTALLED_VERSION) {
  $CC_VERSION = $INSTALLED_VERSION
  Warn "could not query npm (offline?) — falling back to the installed v$CC_VERSION"
} else {
  Die 'cannot determine a target version: npm unavailable and no Claude Code installed. Pass --version X.Y.Z.'
}

if ($SUPPORTED_LATEST) { Ok "newest catalog we ship: v$SUPPORTED_LATEST" }
else { Warn "no completed catalog in $PROMPTS_DIR — gen-catalog needs one to seed id carry-forward (see the seed resolution below)." }
if ($NPM_LATEST) { Ok "newest on npm: v$NPM_LATEST" }
if ($INSTALLED_VERSION) { Ok "installed: v$INSTALLED_VERSION" }
Ok "target version: v$CC_VERSION"

# Nothing-to-do: we already have a FINISHED catalog for the target and no
# --force. A catalog left behind by a run that died mid-pipeline does not count
# — resume it instead of reporting success and doing nothing.
if (Test-Path (Join-Path $PROMPTS_DIR "prompts-$CC_VERSION.json")) {
  if (Test-Path (Join-Path $PROMPTS_DIR "prompts-$CC_VERSION.json.incomplete")) {
    Warn "a previous run for v$CC_VERSION did not finish — regenerating its catalog (classification results already in data/string-catalog.json are reused, not re-billed)."
  } elseif (-not $FORCE) {
    Ok "already support v$CC_VERSION — nothing to do (use --force to regenerate, or --version to target another release)."
    exit 0
  }
}
if ($SUPPORTED_LATEST -and $CC_VERSION -ne $SUPPORTED_LATEST) {
  $newest = (Sort-Versions @($CC_VERSION, $SUPPORTED_LATEST)) | Select-Object -Last 1
  if ($newest -eq $CC_VERSION) {
    Log "adding support for v$CC_VERSION (newer than our latest v$SUPPORTED_LATEST)"
  } else {
    Warn "target v$CC_VERSION is OLDER than our latest catalog v$SUPPORTED_LATEST — regenerating it anyway"
  }
}

$NEW_CATALOG = Join-Path $PROMPTS_DIR "prompts-$CC_VERSION.json"
$SEED_FROM_SELF = $false

# The carry-forward seed is preferably the PREVIOUS release's catalog, never a
# half-built one. An interrupted run leaves an anonymous-entry
# prompts-$CC_VERSION.json on disk, and seeding from that silently destroys the
# sync. The .incomplete marker is what tells the two apart.
$PREV_CATALOG = Get-LatestCompleteCatalog $CC_VERSION
if ($PREV_CATALOG) {
  Ok "carry-forward seed: $(Split-Path $PREV_CATALOG -Leaf)"
} elseif ((Test-Path $NEW_CATALOG) -and -not (Test-Path "$NEW_CATALOG.incomplete")) {
  # Nothing older survives — the normal state after a successful sync, since
  # step 6b prunes every superseded catalog. Re-syncing a version whose OWN
  # catalog is complete can safely seed from it. (Copied into $WORK below so
  # gen-catalog is never reading the file it is writing.)
  Ok "carry-forward seed: prompts-$CC_VERSION.json (this version's own completed catalog — no older one survives pruning)"
  $SEED_FROM_SELF = $true
} else {
  Die "no catalog to seed id carry-forward from: $PROMPTS_DIR has no completed prompts-*.json. Restore one from git (git checkout -- data/prompts) — gen-catalog cannot assign curated ids without a seed."
}

# Only discard the work dir on SUCCESS. It holds the relabel chunks and the
# Claude-authored labels-*.json — hours of model output that cannot be
# regenerated cheaply. Wiping it on a failed run turns a recoverable validation
# error into a full re-label.
$WORK = Join-Path $env:TEMP "unnerfcc-upgrade-$CC_VERSION-$([guid]::NewGuid().ToString('N').Substring(0, 4))"
New-Item -ItemType Directory -Path $WORK -Force | Out-Null
$CLI_JS = Join-Path $WORK 'cli-js'   # a directory (one file per Bun module) since v2.1.251's multi-module build
$SUCCESS = $false
$PATCHED_BIN = ''

try {
  # --- obtain the target native binary ---------------------------------------
  # Reuse an already-installed binary at the target version; otherwise fetch that
  # EXACT version into a temp prefix under $WORK — the maintainer's global install
  # is never touched.
  #
  # The installed binary is only usable if it is STOCK. On any machine that has run
  # .\install.ps1 it is unnerfcc's OWN patched build, and unpacking that feeds our
  # un-nerfed prose back in as if it were Anthropic's.
  #
  # On Windows `claude` on PATH is usually npm's .cmd/.ps1 SHIM, not the native PE,
  # so it is resolved through to the package's bin\claude.exe; the native
  # installer's %USERPROFILE%\.local\bin\claude.exe is used directly.
  function Resolve-ClaudeBinary([string]$Launcher) {
    $p = $Launcher
    for ($hop = 0; $hop -lt 8; $hop++) {
      $item = Get-Item $p -Force -ErrorAction SilentlyContinue
      if (-not $item) { break }
      $target = $item.Target
      if (-not $target) { break }
      if ($target -is [array]) { $target = $target[0] }
      if ($target.StartsWith('\??\')) { $target = $target.Substring(4) }
      if (-not [System.IO.Path]::IsPathRooted($target)) { $target = Join-Path (Split-Path $p -Parent) $target }
      $p = $target
    }
    if ($p -notmatch '\.exe$') {
      $exe = Join-Path (Split-Path $p -Parent) 'node_modules\@anthropic-ai\claude-code\bin\claude.exe'
      if (Test-Path $exe) { return (Resolve-ClaudeBinary $exe) }
    }
    return $p
  }

  Log "Resolving the v$CC_VERSION native binary"
  $CC_BIN = ''
  if ($INSTALLED_VERSION -eq $CC_VERSION -and $claudeCmd) {
    $LAUNCHER = $claudeCmd.Source
    $candidate = Resolve-ClaudeBinary $LAUNCHER
    if ((Test-Path $candidate) -and (Test-Unnerfed $candidate)) {
      Warn 'installed binary is unnerfcc''s own patched build — fetching a stock copy instead (unpacking a patched binary would poison the catalog with our own un-nerfs).'
    } elseif (Test-Path $candidate) {
      Ok "using installed binary: $candidate (v$CC_VERSION, stock)"
      $CC_BIN = $candidate
    }
  }
  if (-not $CC_BIN) {
    if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
      Die "need the v$CC_VERSION binary but npm is unavailable to fetch it"
    }
    Log 'Fetching Claude Code (temp prefix — your global install is untouched)'
    $DL = Join-Path $WORK 'cc'
    New-Item -ItemType Directory -Path $DL -Force | Out-Null
    $rc = Invoke-Streamed 'npm' @('install', '--prefix', $DL, "@anthropic-ai/claude-code@$CC_VERSION", '--no-audit', '--no-fund', '--loglevel=error') '  '
    if ($rc -ne 0) { Die "npm could not fetch @anthropic-ai/claude-code@$CC_VERSION" }
    $CC_BIN = Join-Path $DL 'node_modules\@anthropic-ai\claude-code\bin\claude.exe'
    if (-not (Test-Path $CC_BIN)) { Die "fetched the package but the native binary is missing at $CC_BIN (postinstall may have failed — unsupported platform?)" }
    $RES = Read-ClaudeVersion $CC_BIN
    if ($RES -ne $CC_VERSION) { Warn "fetched binary reports v$RES (expected v$CC_VERSION) — continuing" }
    Ok "fetched binary: $CC_BIN (v$RES)"
  }

  # A working `claude` for the semantic relabel step: the installed one if present,
  # else the binary we just fetched (stock CC — fine for an AI relabel call; it
  # shares ~/.claude auth).
  $CLAUDE_FOR_RELABEL = if ($claudeCmd) { $claudeCmd.Source } else { $CC_BIN }
  # Pinned, not inherited: relabel decides the `<id>.md` filenames every un-nerf
  # rule is keyed to, so it gets the same model as classification.
  $RELABEL_MODEL = if ($env:RELABEL_MODEL) { $env:RELABEL_MODEL } else { 'claude-opus-5' }

  if ($LLM_PROVIDER -eq 'gemini') {
    Ok "AI steps (classify, relabel, bucket-analyze): gemini ($GEMINI_MODEL_RESOLVED)"
  } else {
    Ok "AI steps (classify, relabel, bucket-analyze): claude CLI ($RELABEL_MODEL)"
  }

  # --- 1. unpack the binary (Bun-format-change aware) ------------------------
  Log 'Unpacking JS bundle from the native binary'
  $UNPACK_OUT = Invoke-Native 'node' @($NATIVE_CLI, 'unpack', $CC_BIN, $CLI_JS)
  if ($UNPACK_OUT.Out -match 'BUN_FORMAT_INCOMPATIBLE' -or $UNPACK_OUT.Rc -eq 3) { Stop-BunIncompatible $UNPACK_OUT.Out }
  if ($UNPACK_OUT.Rc -ne 0) { Die "unpack failed (rc=$($UNPACK_OUT.Rc)): $($UNPACK_OUT.Out)" }
  if ($UNPACK_OUT.Out -notmatch "version=$CC_VERSION") { Warn "unpacked JS version tag != $CC_VERSION (continuing)" }
  $UNPACK_BYTES = 0;  if ($UNPACK_OUT.Out -match 'bytes=(\d+)')   { $UNPACK_BYTES   = [int]$Matches[1] }
  $UNPACK_MODULES = '?'
  if ($UNPACK_OUT.Out -match 'modules=(\d+)') { $UNPACK_MODULES = $Matches[1] }
  Ok ('unpacked {0:N1}MB of JS across {1} module(s)' -f ($UNPACK_BYTES / 1MB), $UNPACK_MODULES)

  # --- 1b. classify new strings via the AI provider --------------------------
  # SHA-256-fingerprint every string; only strings NEW to this build (or prompts
  # judged under an older un-nerf policy version) are sent to the model. The store
  # (data/string-catalog.json) persists, so this is cheap on a normal upgrade.
  Log "Classifying new strings via $LLM_PROVIDER (cached by SHA-256)"
  # classify.mjs's own "ONE JOB, NOT MANY" policy puts every pending string in a
  # single call by default, but a single spawnSync call is hard-capped at 30 min;
  # CLASSIFY_BATCH keeps each call under that ceiling for an oversized bootstrap.
  $CLASSIFY_BATCH = if ($env:CLASSIFY_BATCH) { $env:CLASSIFY_BATCH } else { '300' }
  $PENDING = '?'
  $dry = Invoke-Native 'node' @((Join-Path $REPO 'scripts\classify.mjs'), $CLI_JS, $CC_VERSION, '--provider', $LLM_PROVIDER, '--dry-run')
  if ($dry.Rc -eq 0 -and $dry.Out -match '"toClassify":(\d+)') { $PENDING = $Matches[1] }

  if ($PENDING -eq '0') {
    Ok 'no new strings — classification store is current'
  } elseif ($PENDING -ne '?' -and [int]$PENDING -gt 2000 -and -not $ASSUME_YES) {
    Warn "$PENDING strings need classifying (a first-run bootstrap — a large $LLM_PROVIDER job, chunked at $CLASSIFY_BATCH/call)."
    $answer = Read-Host '  Run it now? [y/N]'
    if ($answer -match '^[yY]') {
      if ((Invoke-Streamed 'node' @((Join-Path $REPO 'scripts\classify.mjs'), $CLI_JS, $CC_VERSION, '--provider', $LLM_PROVIDER, '--batch', $CLASSIFY_BATCH)) -ne 0) {
        Warn 'classification incomplete (store is resumable)'
      }
    } else {
      Warn "skipped — run 'node scripts/classify.mjs $CLI_JS $CC_VERSION --provider $LLM_PROVIDER --batch $CLASSIFY_BATCH' later"
    }
  } else {
    $crc = Invoke-Streamed 'node' @((Join-Path $REPO 'scripts\classify.mjs'), $CLI_JS, $CC_VERSION, '--provider', $LLM_PROVIDER, '--batch', $CLASSIFY_BATCH)
    if ($crc -ne 0) { Warn 'classification incomplete (store is resumable)' }
    if (Test-Path (Join-Path $REPO 'data\unnerf-candidates.json')) { Ok 'un-nerf candidates for review: data/unnerf-candidates.json' }
  }

  # --- 2. extract a fresh catalog (seeded) -----------------------------------
  # Mark the catalog mid-build BEFORE writing a byte of it, and leave the marker
  # there until step 6 has verified the patched binary.
  Log 'Extracting prompt catalog (seeded from previous for id carry-forward)'
  if ($SEED_FROM_SELF) {
    $PREV_CATALOG = Join-Path $WORK "seed-prompts-$CC_VERSION.json"
    Copy-Item $NEW_CATALOG $PREV_CATALOG -Force
  }
  [System.IO.File]::WriteAllText("$NEW_CATALOG.incomplete", '')
  if ((Invoke-Streamed 'node' @((Join-Path $REPO 'scripts\gen-catalog.mjs'), $CLI_JS, $CC_VERSION, $NEW_CATALOG, $PREV_CATALOG)) -ne 0) {
    Die 'gen-catalog failed'
  }
  Ok "catalog: $NEW_CATALOG"

  # --- 3. diff + relabel worklist --------------------------------------------
  if ($PREV_CATALOG) {
    Log 'SHA-256 diff vs previous catalog'
    Show-Indented (Invoke-Native 'node' @((Join-Path $REPO 'scripts\prompt-index.mjs'), 'diff', $PREV_CATALOG, $NEW_CATALOG)).Out

    Log 'Preparing relabel worklist'
    $RL_WORK = Join-Path $WORK 'relabel'
    $prep = Invoke-Native 'node' @((Join-Path $REPO 'scripts\relabel.mjs'), 'prepare', $PREV_CATALOG, $NEW_CATALOG, $RL_WORK)
    $N = 0
    if ($prep.Out -match 'worklist: (\d+)') { $N = [int]$Matches[1] }

    if ($N -gt 0) {
      # ONE job per chunk. A single job asked to emit ~1000 objects truncates and
      # the merge then hard-fails on missing refs; `collect` re-checks every ref
      # and we re-run only the chunks that came back short.
      $chunks = @(Get-ChildItem $RL_WORK -Filter 'chunk-*.json' -File)
      Log "Labeling $N new/changed fragment(s) via $LLM_PROVIDER in $($chunks.Count) chunk(s)"
      for ($attempt = 1; $attempt -le 3; $attempt++) {
        foreach ($chunk in $chunks) {
          $cn = $chunk.BaseName -replace '^chunk-', ''
          if (Test-Path (Join-Path $RL_WORK "labels-$cn.json")) { continue }   # already labeled
          Log "  labeling chunk $cn (attempt $attempt)"
          if ($LLM_PROVIDER -eq 'gemini') {
            Invoke-Streamed 'node' @((Join-Path $REPO 'scripts\relabel.mjs'), 'label', $RL_WORK, $cn) | Out-Null
          } else {
            $task = "Read LABELING-TASK.md in this directory and follow it EXACTLY. Your assigned chunk file is chunk-$cn.json and you MUST write your labels to labels-$cn.json in this directory (a JSON array with exactly one object per item in chunk-$cn.json, echoing each ref verbatim — refs are global indices, they do not start at 0). The un-nerf guide is $REPO\UNNERF-GUIDE.md ; the previous catalog is $PREV_CATALOG . Also read removed.json (ids that vanished this release — a reworded prompt appears as a removed id plus a new worklist item, and you MUST re-use its id verbatim or its un-nerf rule is orphaned). Do not ask questions; complete the task and write the file."
            Push-Location $RL_WORK
            try { Invoke-Streamed $CLAUDE_FOR_RELABEL @('-p', '--dangerously-skip-permissions', '--model', $RELABEL_MODEL, $task) | Out-Null }
            finally { Pop-Location }
          }
        }
        if ((Invoke-Streamed 'node' @((Join-Path $REPO 'scripts\relabel.mjs'), 'collect', $RL_WORK, $NEW_CATALOG)) -eq 0) { break }
        if ($attempt -eq 3) { Die "relabel incomplete after 3 attempts (see $RL_WORK)" }
        Log '  re-running short chunks'
        foreach ($chunk in $chunks) {
          $cn = $chunk.BaseName -replace '^chunk-', ''
          Invoke-Native 'node' @('-e', $script:DropShortLabelsJs, $chunk.FullName, (Join-Path $RL_WORK "labels-$cn.json")) | Out-Null
        }
      }
      if (-not (Test-Path (Join-Path $RL_WORK 'labels.json'))) { Die 'relabel did not produce labels.json' }
      Log 'Merging labels into the catalog'
      if ((Invoke-Streamed 'node' @((Join-Path $REPO 'scripts\relabel.mjs'), 'merge', $NEW_CATALOG, (Join-Path $RL_WORK 'labels.json'), $NEW_CATALOG)) -ne 0) {
        Die 'relabel merge failed'
      }
      Ok "relabeled + merged $N fragment(s)"
    } else {
      Ok 'no fragments need relabeling (extractor identified everything)'
    }

    # Did any reworded prompt gain/lose a brevity/effort nerf? MUST run AFTER the
    # relabel merge: matching is by exact hash, so a reworded prompt has no entry
    # in the new catalog until relabel re-attaches its old id.
    Log 'Checking un-nerf status changes on reworded prompts'
    $us = Invoke-Native 'node' @((Join-Path $REPO 'scripts\unnerf-status.mjs'), 'changes', $PREV_CATALOG, $NEW_CATALOG)
    Show-Indented $us.Out
    if ($us.Rc -ne 0) { Warn 'un-nerf status check failed (non-fatal)' }
  }

  # --- 4. validate catalog ----------------------------------------------------
  # ACK_REMOVED=<N>: after manually verifying that a large id-removal is genuine
  # upstream deletion (see validate-catalog gate 6), re-run with ACK_REMOVED set to
  # the exact removed count to let the pipeline proceed.
  Log 'Validating catalog (structural gates)'
  $valArgs = @((Join-Path $REPO 'scripts\validate-catalog.mjs'), $NEW_CATALOG)
  if ($PREV_CATALOG) { $valArgs += $PREV_CATALOG }
  $valArgs += '--strict'
  if ($env:ACK_REMOVED) { $valArgs += @('--ack-removed', $env:ACK_REMOVED) }
  if ((Invoke-Streamed 'node' $valArgs) -ne 0) { Die 'catalog validation failed' }
  Ok 'catalog gates pass'

  # --- 5. reconstruct stock .md -----------------------------------------------
  Log 'Reconstructing stock prompts'
  if ((Invoke-Streamed 'node' @((Join-Path $REPO 'scripts\sync-version.mjs'), $CC_VERSION)) -ne 0) { Die 'sync-version failed' }

  # --- 5b. bucket-analyze new un-nerf candidates ------------------------------
  if (Test-Path $BUCKET_ANALYZE) {
    Log 'Preparing un-nerf bucket-analysis worklist'
    $BA_WORK = Join-Path $WORK 'bucket-analysis'
    $bprep = Invoke-Native 'node' @($BUCKET_ANALYZE, 'prepare', $CC_VERSION, $BA_WORK)
    $M = 0
    if ($bprep.Out -match 'worklist: (\d+)') { $M = [int]$Matches[1] }

    if ($M -gt 0) {
      $baChunks = @(Get-ChildItem $BA_WORK -Filter 'chunk-*.json' -File)
      Log "Bucket-analyzing $M new un-nerf candidate(s) via $LLM_PROVIDER in $($baChunks.Count) chunk(s)"
      for ($attempt = 1; $attempt -le 3; $attempt++) {
        foreach ($chunk in $baChunks) {
          $cn = $chunk.BaseName -replace '^chunk-', ''
          if (Test-Path (Join-Path $BA_WORK "verdicts-$cn.json")) { continue }   # already analyzed
          Log "  analyzing chunk $cn (attempt $attempt)"
          if ($LLM_PROVIDER -eq 'gemini') {
            Invoke-Streamed 'node' @($BUCKET_ANALYZE, 'label', $BA_WORK, $cn) | Out-Null
          } else {
            $task = "Read BUCKET-ANALYSIS-TASK.md in this directory and follow it EXACTLY. Your assigned chunk file is chunk-$cn.json and you MUST write your verdicts to verdicts-$cn.json in this directory (a JSON array with exactly one object per item in chunk-$cn.json, echoing each ref verbatim — refs are global indices, they do not start at 0). The un-nerf guide is $REPO\UNNERF-GUIDE.md ; read its Part 1 in full before deciding anything. Do not ask questions; complete the task and write the file."
            Push-Location $BA_WORK
            try { Invoke-Streamed $CLAUDE_FOR_RELABEL @('-p', '--dangerously-skip-permissions', '--model', $RELABEL_MODEL, $task) | Out-Null }
            finally { Pop-Location }
          }
        }
        if ((Invoke-Streamed 'node' @($BUCKET_ANALYZE, 'collect', $BA_WORK)) -eq 0) { break }
        if ($attempt -eq 3) { Die "bucket-analysis incomplete after 3 attempts (see $BA_WORK)" }
        Log '  re-running short chunks'
        foreach ($chunk in $baChunks) {
          $cn = $chunk.BaseName -replace '^chunk-', ''
          Invoke-Native 'node' @('-e', $script:DropShortLabelsJs, $chunk.FullName, (Join-Path $BA_WORK "verdicts-$cn.json")) | Out-Null
        }
      }
      if (-not (Test-Path (Join-Path $BA_WORK 'verdicts.json'))) { Die 'bucket-analysis did not produce verdicts.json' }
      Log 'Merging accepted un-nerf rules into apply-unnerfs.py'
      if ((Invoke-Streamed 'node' @($BUCKET_ANALYZE, 'merge', $BA_WORK, (Join-Path $REPO 'scripts\apply-unnerfs.py'), $CC_VERSION)) -ne 0) {
        Die 'bucket-analysis merge failed — see output above'
      }
      Ok "bucket-analysis complete — full keep/lift review: data/bucket-analysis-$CC_VERSION.json"
    } else {
      Ok 'no new un-nerf candidates to bucket-analyze'
    }
  } else {
    Warn 'scripts/bucket-analyze.mjs missing — skipping automated bucket-analysis (fall back to the manual UNNERF-GUIDE Part 1 pass)'
  }

  # --- 5c. replay un-nerfs (existing + any bucket-analyze just added) ---------
  Log 'Replaying un-nerfs'
  if ((Invoke-Streamed $PYTHON @((Join-Path $REPO 'scripts\apply-unnerfs.py')) '  ') -ne 0) { Die 'apply-unnerfs.py failed' }
  if ((Invoke-Streamed $PYTHON @((Join-Path $REPO 'scripts\apply-unnerfs.py'), '--check') '  ') -ne 0) { Die 'apply-unnerfs --check not clean after sync' }
  Ok 'un-nerfs applied + idempotent'

  # --- 6. verify the un-nerfs actually patch the binary ----------------------
  if ($PATCH_VERIFY -and (Test-Path $PATCH_CLI)) {
    Log 'Verifying un-nerfs patch the binary (vendored patcher + repack + boot-check)'
    $PATCHED_JS = Join-Path $WORK 'patched-js'
    $PATCHED_BIN = Join-Path $WORK 'claude-patched.exe'
    # Release gate: exit 3 means a real un-nerf failed to splice (see [LOST] banner)
    # — block the release so the drifted anchor gets fixed. exit 2 = invalid output.
    $SPLICE = Invoke-Native 'node' @($PATCH_CLI, 'apply', $CLI_JS, $NEW_CATALOG, $SYS_PROMPTS, $PATCHED_JS)
    Show-Indented $SPLICE.Out
    if ($SPLICE.Rc -ne 0) { Die "prompt splice reported failures (exit $($SPLICE.Rc)) — fix before releasing (see output above)" }

    # --- effort un-nerfs (BEST-EFFORT) + posture drift detection --------------
    # A failure here never blocks the prompt un-nerfs. The stock effort "posture"
    # is snapshotted and diffed against the committed manifest, so a change in CC's
    # effort surface surfaces as a LOUD worklist, not a silent regression.
    $POSTURE = Join-Path $REPO 'data\effort-posture.json'
    $POSTURE_NEW = Join-Path $WORK 'effort-posture.json'
    $post = Invoke-Native 'node' @((Join-Path $REPO 'engine\apply-code-patches.mjs'), 'posture', $CLI_JS)
    if ($post.Rc -eq 0 -and $post.Out.Trim()) { [System.IO.File]::WriteAllText($POSTURE_NEW, $post.Out) }
    $EFF_JS = Join-Path $WORK 'patched-effort-js'
    $EFF = Invoke-Native 'node' @((Join-Path $REPO 'engine\apply-code-patches.mjs'), 'apply', $CLI_JS, $PATCHED_JS, $EFF_JS)
    Show-Indented $EFF.Out
    if (Test-Path $EFF_JS) { $PATCHED_JS = $EFF_JS }
    if ($EFF.Out -match 'SOME MISSING') {
      Warn "effort un-nerf incomplete — CC's effort code likely changed; update engine/apply-code-patches.mjs anchors. Prompt un-nerfs are unaffected."
    }
    if ((Test-Path $POSTURE) -and (Test-Path $POSTURE_NEW) -and
        ((Get-FileHash $POSTURE).Hash -ne (Get-FileHash $POSTURE_NEW).Hash)) {
      Warn 'CC effort surface changed since last release — review the diff:'
      $d = Compare-Object (Get-Content $POSTURE) (Get-Content $POSTURE_NEW) -IncludeEqual:$false
      foreach ($line in $d) { Write-Host "    $(if ($line.SideIndicator -eq '<=') { '-' } else { '+' }) $($line.InputObject)" }
    }
    if ((Test-Path $POSTURE_NEW) -and (Get-Item $POSTURE_NEW).Length -gt 0) { Copy-Item $POSTURE_NEW $POSTURE -Force }

    $REPACK = Invoke-Native 'node' @($NATIVE_CLI, 'repack', $CC_BIN, $PATCHED_JS, $PATCHED_BIN)
    if ($REPACK.Out -match 'BUN_FORMAT_INCOMPATIBLE') { Stop-BunIncompatible $REPACK.Out }
    if ($REPACK.Rc -ne 0) { Die "repack failed: $($REPACK.Out)" }
    $boot = Invoke-Native $PATCHED_BIN @('--version')
    if ($boot.Rc -ne 0) { Die 'patched binary failed boot-check' }
    Ok 'patched binary boots'

    # sentinel spot-check
    $MISS = 0
    foreach ($sent in 'senior-engineer standard',
                      'never trade away rigor, depth, or correctness',
                      'thorough, clear, and rich with explanation') {
      $chk = Invoke-Native 'node' @('-e', $script:SentinelDirJs, $PATCHED_JS, $sent)
      if ($chk.Rc -ne 0) { Warn "sentinel missing from patched JS: $sent"; $MISS++ }
    }
    if ($MISS -eq 0) { Ok 'un-nerf sentinels present in patched binary' }
  } else {
    Warn 'skipping patch-verify (patch-prompts.mjs not built or --no-patch-verify)'
    $PATCHED_BIN = ''
  }

  # --- 6b. finalize: prune superseded catalogs, clear the mid-build marker ----
  # We only ever need the newest prompts-*.json: it is BOTH what ships AND the
  # carry-forward seed for the next upgrade. This deliberately runs LAST, not
  # right after the step-4 gates: the previous catalog is the only seed a re-run
  # has, so deleting it before the pipeline can finish is unrecoverable-by-script.
  #
  # The `.candidates.json` sidecar matches this same glob, so it needs the same
  # exemption, or the review artifact gen-catalog wrote never survives to be
  # committed while the previous release's tracked copy shows as deleted.
  $PRUNED = 0
  $NEW_CANDIDATES = ($NEW_CATALOG -replace '\.json$', '') + '.candidates.json'
  foreach ($old in @(Get-ChildItem $PROMPTS_DIR -Filter 'prompts-*.json' -File -ErrorAction SilentlyContinue)) {
    if ($old.FullName -eq $NEW_CATALOG) { continue }
    if ($old.FullName -eq $NEW_CANDIDATES) { continue }
    Remove-Item $old.FullName -Force -ErrorAction SilentlyContinue
    Remove-Item "$($old.FullName).incomplete" -Force -ErrorAction SilentlyContinue
    $PRUNED++
  }
  if ($PRUNED -gt 0) { Ok "pruned $PRUNED superseded catalog(s) — only prompts-$CC_VERSION.json remains (git will show them deleted)" }
  Remove-Item "$NEW_CATALOG.incomplete" -Force -ErrorAction SilentlyContinue

  # --- 7. OPTIONAL benchmark (--benchmark) -----------------------------------
  # Stock vs patched accuracy on SWE-bench. OPT-IN and HEAVY (Docker + hours);
  # best-effort — a benchmark failure never fails the upgrade.
  if ($BENCHMARK) {
    if ($PATCH_VERIFY -and $PATCHED_BIN -and (Test-Path $PATCHED_BIN)) {
      Log "Benchmarking stock vs patched v$CC_VERSION (SWE-bench, n=$BENCH_N) — this is slow"
      if ((Invoke-Streamed 'node' @((Join-Path $REPO 'scripts\benchmark.mjs'), $CC_BIN, $PATCHED_BIN, $CC_VERSION, $BENCH_N)) -ne 0) {
        Warn 'benchmark step did not complete — the upgrade itself is unaffected (see data/benchmark/*.log)'
      }
    } else {
      Warn "--benchmark needs the patched binary from patch-verify — don't combine it with --no-patch-verify."
    }
  } else {
    Log 'Benchmark skipped. To compare stock vs patched accuracy: .\upgrade.ps1 --benchmark[=N]  (heavy: Docker + hours)'
  }

  # --- done -------------------------------------------------------------------
  Log "Upgrade prepared for v$CC_VERSION"
  Write-Host @"

  Review, then commit:
    - data/prompts/prompts-$CC_VERSION.json   (new catalog — WE own this now)
    - data/prompts/prompts-*.json (deleted)   (superseded catalogs — 'git add' the deletions)
    - system-prompts/*.md                     (reconstructed + un-nerfed)
    - system-prompt-checksums.json            (regenerated by sync-version)
    - scripts/apply-unnerfs.py                (bucket-analysis may have added new rules)
    - data/bucket-analysis-$CC_VERSION.json   (full keep/lift review, incl. every KEEP + why)
    - scripts/*, engine/*                     (if changed)

  Bucket-analysis (deciding which new/changed prompts need a new un-nerf rule,
  and drafting it) already ran automatically above — see
  data/bucket-analysis-$CC_VERSION.json for the full review before committing.
  apply-unnerfs.py --check already gates this step, so anything in
  scripts/apply-unnerfs.py has already passed; this file is for AUDIT, not
  redoing the analysis. If bucket-analyze.mjs was skipped or rejected a
  candidate you disagree with, that's the one case left for a manual
  UNNERF-GUIDE Part 1 pass.
"@

  $SUCCESS = $true
} finally {
  if ($SUCCESS) {
    Remove-Item $WORK -Recurse -Force -ErrorAction SilentlyContinue
  } else {
    Warn "work dir PRESERVED for recovery: $WORK"
  }
}
