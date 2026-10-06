# Windows support

`install.ps1` and `upgrade.ps1` are PowerShell 7 ports of [`install.sh`](install.sh) and
[`upgrade.sh`](upgrade.sh) — same steps, same flags, same exit codes. The engine can now patch the
Windows binary too, which it previously could not parse at all.

```powershell
pwsh -NoProfile -File .\install.ps1            # --help for options, --dry-run to preview
pwsh -NoProfile -File .\upgrade.ps1            # maintainer sync to a new CC release
```

Requires PowerShell **7** (`pwsh`), not the 5.1 that ships with Windows — the scripts declare
`#Requires -Version 7.0`. Node ≥ 20 and a working Python 3 as before.

---

## The blocker: Bun's Windows binary is a PE

Porting the shell scripts was the small half. The engine was the wall.

`engine/bun-binary.mjs` recognised exactly two container formats — ELF (Linux) and Mach-O (macOS) —
and threw `BUN_FORMAT: unrecognized binary format` on anything else. Claude Code on Windows is a
PE32+ executable (`claude.exe`, ~250 MB), so every path through both scripts died at the first
unpack, on any machine, forever. A PowerShell port alone would have been a faithful port of
something that cannot run.

The good news is that Bun keeps the same convention on Windows: the module blob still lives in a
section named **`.bun`**, and the Windows runtime finds it through the **PE section table**. That
makes PE the easiest of the three formats to support:

| | Locate the blob | Grow it | Signature |
|---|---|---|---|
| **ELF** | a baked-in vaddr the static linker resolved | move the section, **patch the pointer** | — |
| **Mach-O** | `__BUN,__bun` segment | extend in place | **must re-sign** (enforced, esp. Apple Silicon) |
| **PE** | section table entry | resize the section, let LIEF relayout | nothing enforced |

No address to hunt down and patch, no re-sign step. `findBunSectionPE()` reads the section table
directly; `repackPE()` sets both the raw and virtual size to the new length and hands the relayout
to LIEF. Raw PE sections are `FileAlignment`-padded, so the blob length now comes from the size
header inside the section rather than from the section's on-disk size — with up to 4 KiB of
tolerance, which is a strict superset of the exact-equality check ELF and Mach-O already passed.

Windows module names are also drive-letter shaped (`B:/~BUN/root/…`) rather than
`/$bunfs/root/…`, so both the module-path sanitiser and the module-table validator accept either
form — `:` is not a legal filename character, so the drive prefix has to come off before writing
modules to disk.

> This PE work was ported from [`brooksbUWO/unnerfcc`](https://github.com/brooksbUWO/unnerfcc)
> (`windows-pe-support` / `windows-pe-2`), which had already reverse-engineered the container. Only
> the PE hunks were taken; that fork's separate `rules/<id>.json` refactor of `apply-unnerfs.py` was
> deliberately **not** merged, and it swaps three of the five sentinel phrases for ones its own rules
> emit — this repo keeps the upstream five.

---

## What a Windows port actually has to know

The bash → PowerShell translation is mechanical except for four things that are genuinely different
here.

| | `install.sh` / `upgrade.sh` | `.ps1` |
|---|---|---|
| Target binary | `command -v claude` + `readlink -f` | npm's global `claude` is a **`.cmd`/`.ps1` shim**, not the binary — followed through to `<dir>\node_modules\@anthropic-ai\claude-code\bin\claude.exe`; the native installer's `%USERPROFILE%\.local\bin\claude.exe` is used directly |
| Interpreter | `python3` | resolved by **execution probe** over `python`, `python3`, `py` — a name that resolves to the Microsoft Store stub exits without running anything, so `Get-Command` success proves nothing. The `.mjs` scripts do the same on `win32` |
| npm global bin | `$(npm config get prefix)/bin` | the prefix **is** the bin dir; there is no `/bin` |
| Swapping the binary | `cp` → `chmod` → `mv -f` | `[IO.File]::Replace` — NTFS has ACLs, not POSIX mode bits, and a running Claude Code locks its own exe, so the failure is a sharing violation with a message that says so |

Two smaller ones: `mktemp -d` + `trap` became a GUID work dir under `$TEMP` with `try`/`finally`
(the work dir is still preserved on failure, because it holds hours of model output), and every file
handed to the `.mjs` scripts is written UTF-8 **without a BOM** — `JSON.parse` rejects a BOM, and
PowerShell's default encoding adds one.

### Why `set -e` has no direct equivalent

PowerShell does not abort on a native command's non-zero exit, and under `$ErrorActionPreference =
'Stop'` it turns a native command's *stderr* into a terminating error — so a tool that merely logs to
stderr would kill the run. Both scripts wrap native calls in two helpers instead: `Invoke-Native`
(capture stdout+stderr plus exit code, like `$(cmd 2>&1)`) and `Invoke-Streamed` (same, but line by
line, so a multi-minute AI step stays observable). Every exit code is then checked explicitly, which
is what `set -euo pipefail` was doing implicitly.

---

## Bugs caught by porting this

Worth recording, because none of them are visible in a diff review.

1. **`[IO.File]::Replace($tmp, $CC_BIN, $null)` throws `The path is empty`.** .NET wants a real
   backup name, not null. This sat on the last step of the install — the one destructive step — so
   every run would have built, boot-checked and then died holding a patched binary it could not
   install. Fixed by passing a backup name, which is a *rename* of the outgoing binary, not a copy,
   so it costs no disk.
2. **`'\n+$'` in single quotes is a literal backtick-n, not a newline.** The trailing newline
   survived the strip, `Select-Object -Last 1` then returned the empty final element, so
   `NPM_LATEST` was silently always empty — which quietly disabled the "Claude Code is newer than our
   newest catalog, run upgrade" warning. It surfaced only because the warning failed to fire on a
   machine where it provably should have.
3. **`npm install` ran in the repo root** instead of `engine/` / `scripts/`; bash had the `cd` inside
   a subshell. Caught by deleting `node_modules` and running the bootstrap for real.
4. **Pre-existing, and independent of this port:** with `core.autocrlf=true` and no `.gitattributes`,
   a Windows clone checks out `install.sh` and `upgrade.sh` with **CRLF** (`git ls-files --eol`
   reports `i/lf w/crlf`), and bash cannot execute them — it dies on the shebang. The repo was
   therefore unrunnable on Windows from a fresh clone, in both directions. `.gitattributes` now pins
   `* text=auto eol=lf`, which also matters because `sync-version.mjs` and `apply-unnerfs.py` rewrite
   ~6,900 prompt files byte-for-byte and every un-nerf rule matches its prompt by an exact text
   anchor.

   After pulling this in, run `git add --renormalize .` once to settle the existing checkout.

---

## Verification

Against a **stock v2.1.280** fetched into a temp prefix (never an installed binary), on Windows:

```
unpack    format=pe modules=2193 version=2.1.280 bytes=50849034
splice    patched=102 runs=120 unchanged=6765 lost=5
effort    floor-default-effort, uncap-effort-enum, validator-accepts-max — all applied
repack    237100192 → 237170957 bytes (grown +70,765, i.e. the resize path, not a no-op)
boot      2.1.280 (Claude Code)
sentinels senior-engineer standard · never trade away rigor, depth, or correctness
          · thorough, clear, and rich with explanation   — all present
```

The grown-blob case is the one that matters: a same-size repack would not have exercised LIEF's
relayout. Separately, `sync-version.mjs` + `apply-unnerfs.py` run on Windows reproduce the committed
prompt set **byte-identically** — `git diff` reports zero changed files and
`system-prompt-checksums.json` is unchanged — so the Python and Node writers are line-ending clean.

Also exercised: `--help`, `--dry-run`, unknown-arg exit 2, `--version` early exit, the
already-supported no-op, the first-run dependency bootstrap, the binary swap semantics, the
auto-updater settings edit across all four states (create / already-set / merge-preserving-existing
/ refuse-to-clobber-corrupt-file), and both sentinel searches returning the right exit codes.

The 5 `lost=5` in the splice above are pre-existing catalog-anchor drift for v2.1.280 and reproduce
identically on Linux — not a Windows artefact.

---

## What still does not work on Windows

- **`--benchmark`** — `scripts/benchmark.mjs` shells out to `bash` and Docker (`df`, `xargs`,
  `python3 -m venv`). It reports skipped rather than failing the upgrade. Porting it means replacing
  its shell layer, which is a separate job.
- **The `.sh` pair still works** under Git Bash if you prefer it — `.gitattributes` is what makes
  that possible.
- **Authenticode.** Patching invalidates any signature on `claude.exe`. Windows does not enforce one
  at launch, but SmartScreen, AppLocker/WDAC policies, or `Get-AuthenticodeSignature` will report the
  binary as unsigned. Same tradeoff the macOS path already makes, just more visible.

Rollback is unchanged: reinstall Claude Code
(`npm install -g @anthropic-ai/claude-code@<version>`). No backup is kept after install.
