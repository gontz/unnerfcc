<!--
name: 'Skill: plugin-authoring'
description: >-
  Bundled plugin-authoring skill — instructions for writing, extending, or
  debugging Claude Code plugins made of function hooks.
ccVersion: 2.1.280
-->
---
name: plugin-authoring
description: Write or debug a Claude Code plugin made of function hooks (a hooks module exporting register(on, options), hooks ($, e, next) on events like tool.call, prompt.submit, ui.render, session.start). Load it before writing or changing such a plugin; it says where the exact types come from, how to run a plugin under development, and where the engine reports what it refused.
---

You are about to write, extend or debug a plugin made of function hooks.
This note is orientation: what such a plugin is, where its exact contract
is written down for the build you are running in, and where to look when
something does not take. Run `claude plugin validate <dir>` on the plugin's folder early and often: it reads the manifest and the hooks
module's source the way the engine will and reports what the module hooks and calls and everything the engine would refuse, before a
session loads it. The API is early access and moves between releases: the generated declarations are the authority, this note the map.

## What a plugin of function hooks is

A plugin is a folder with a `.claude-plugin/plugin.json` manifest. Its
function hooks live in one hooks module: a TypeScript or JavaScript file
that `hooks/hooks.json` names under `modules` (one path, relative to that
file), exporting `register(on, options)`; the module, and every file it imports from the plugin, is named `.ts`, `.tsx`, `.jsx`, `.js`, `.mjs`, `.cjs`, `.mts` or `.cts` (a file named otherwise is not loaded) and is an ES module whatever its suffix. `on(event, matcher?, hook)` adds a
hook; `options` holds the values of the fields the manifest's `userConfig`
declares. Every hook has the shape `($, e, next)`: `$` is the engine
interface (display, model, session, prompt, tools, filesystem, store,
clock, network, host commands, settings, environment, the config menu's rows and the rest), `e` is the event's input as a plain value,
and `next(e)` continues to the other plugins and then the engine's own
behaviour, resolving to the event's result. A hook that returns without
calling `next` answers for itself; one that calls `next({ ...e, ... })`
rewrites what the rest of the chain sees, within what that event allows.
The module runs in an environment of its own, with no DOM and no Node:
everything outside it is reached through `$`. JSX is available with `h` as
the factory.

The events cover tool calls and their descriptions, the prompt as submitted, the system prompt's sections and the first message's context blocks, what the interface
draws, the turn's start, steps and completion, the session's start, end (a /clear too: `session.end` with `reason: 'clear'`, and no `session.start` after it) and deliveries, each hooks module's admission, skills, subagents and attribution text. The settings hooks' own events are hookable as `classic.<Event>` (`classic.Stop`, `classic.SessionEnd`), `e` being what that hook receives on stdin, `transcript_path` and the other base fields included. Which of them a
feature is, and what it needs from `$`, are the two questions worth settling before writing. Two events stream, `turn.step` (a model request of the turn) and
`process.spawn` (a child's output, piece by piece; for the caller `$.process.spawn({ argv })` is the stream and the loop's end is the child's): a hook on either is an
async generator (`async function* ($, e, next) {}`, the one form that loads there); `next(e)` is the stream beneath, `yield* next(e)` forwards it and evaluates to the
result, `for await` over it rewrites the chunks one at a time, yielding without `next` answers alone, and a hook that fails mid-stream is left where it stood.

## The types are the reference

Do not guess at an event's input, a method on `$`, or an element's props.
Run `/plugin-types` in the session (it takes an optional directory and
defaults to `.claude/types`). It writes three files from the running build:
`claude-code.d.ts`, which declares the module `claude-code` (import types
from it; at run time the import is empty), the globals a hooks module has,
and the inputs of this build's built-in tools; `claude-code-plugins.d.ts` and its folder, what the enabled plugins add to `$` (below); and
`claude-code-mcp.d.ts`, the inputs of the MCP tools connected right now, so `e` narrows per tool.
The header of `claude-code.d.ts` carries a `tsconfig.json` that fits a hooks
module and shows how to type `register` against `Register`.

Read that file for every event's input and result, every noun and method on
`$` with its doc comment and example, every element each surface draws and
the props each element accepts, and the limits it states. Shapes there are
the engine's own, not the Messages API's: `$.session.messages()`, for one,
answers `SessionMessage` rows of `{ role, text, toolUses }`, not `content`
blocks. When the build updates, regenerate rather than edit.
`claude plugin validate <path>` reads a plugin's manifest and its hooks
module's source and reports what the module hooks and calls, which is the
quickest check that the engine sees what you meant. A plugin that adds a noun to `$` in `engine.create` ships that noun's types as a contract: one self-contained `.d.ts` (say `types/index.d.ts`) that exports the noun's types at its top level and declares the noun on the engine's interface, `export type Topo = { ... }` then `declare module 'claude-code' { interface EngineInterface { topo: Topo } }`, with no import or reference, its exported names led by the noun's PascalCase name (`Topo`, `TopoRun`), named in `plugin.json` as `"types": "./types/index.d.ts"`. The plugin's own hooks module imports those types from that file, so the contract is the one place they are written. A plugin that depends on it never copies the file: `/plugin-types` copies every enabled plugin's contract to `claude-code-plugins/<plugin>.d.ts` beside an index, `claude-code-plugins.d.ts`, that references each, so the noun is typed on the dependent's `$` from the session it develops in (the tsconfig's include of `.claude/types` takes the folder), and `claude plugin validate` checks a contract exactly as that roll-up reads it.

## Developing one

`claude --plugin-dir <folder>` loads the plugin from disk for that session
only (repeat the flag for several). `CLAUDE_CODE_PLUGIN_DIRS` names the same folders where no flag can be given (a session the desktop app or an SDK host starts): one or more absolute paths (`~` allowed) separated by the platform's path-list separator, each loaded exactly as a `--plugin-dir`, taken from the process environment or the `env` block of `~/.claude/settings.json` (never a project's settings). In an interactive session the folder is
watched, as is a plugin auto-loaded from a skills folder (`~/.claude/skills/<name>`, the project's `.claude/skills/<name>`): saving a file reloads the hooks module, so
`register` runs again in a fresh environment and the previous environment's timers are dropped. Saves made while the session's own turn runs (the model editing the plugin) reload once, when the turn ends, or sooner when a tool or command the plugin registered is about to run, so the turn can try what it wrote. Saves from anywhere else reload once the folder has been quiet: a lone save within a quarter second, a run of saves seconds apart once the run stops. A headless `claude -p` always loads fresh, and a long-lived headless session (SDK, desktop) watches too when `CLAUDE_CODE_PLUGIN_DIR_WATCH=1` is set the same way, its reload lines reaching the host as `ui_log` messages and the debug log.
Options for a plugin loaded this way are read from settings under
`pluginConfigs`, keyed by the plugin's `<name>` (or `<name>@inline`); each non-secret `userConfig` field is a row in the config menu too, and a change there reloads the module with the new `options`. A `string` field that lists `options` (`"options": ["gist", "turbo"]`, its `default` among them) is a picker over exactly those values there, and a stored value outside them counts as unset.

Run with `claude --debug` while developing. A hook that fails is skipped and
the chain continues without it, unless its registration's `.catch` handler
answers in its place; the transcript says so once, in a dim line naming the
plugin, the event and the reason, as it names a module that did not load (a `claude -p` run has no transcript: one printing text names a `--plugin-dir` plugin whose module was not loaded, or failed to load, once on stderr with the reason, the switch being off included, which `CLAUDE_CODE_ENABLE_FUNCTION_HOOKS=1` in that process's environment turns on; a json or stream-json run keeps it in the debug log). The debug log has a line for every occurrence and each result the engine
refused; a skipped hook's line has the error's name and message length in place of its text (the first one's text, cut to a short line, is on that transcript line, which the debug log has too), so a plugin that seems to do nothing has usually been told why. `claude plugin test <folder>` runs the plugin's `*.test.ts` files against the engine itself: a test holds the engine's `$` and an `on` whose hooks sit beneath the plugin (import `test`, `expect`, `mock` from `claude-code/testing`; the typings say the rest). A UI test mounts a component through the plugin on a surface it names, never an assumed one (the kit's `mount` on the test's `ui` noun: `{ plugin, surface, component, props }`), and acts on the drawing by key (`press`, `input`, `find`, a `Client`'s `key` and `post`), each act typed by that surface's element table; write the body once and loop it over `['terminal', 'desktop'] as const` so the test shows the plugin does not depend on one surface. A tree the test drew through the engine's `ui` noun (`render`) is acted on the same way through that noun's `press`, `input` (`{ plugin, key, text, kind? }`: `change` is one edit reaching `onInput`, `submit`, the default, is Enter reaching `onSubmit`) and `select` (`{ plugin, key, value }`); every act resolves only once the chain, the element's own handler and any work that handler left running unawaited have settled, so a test asserts right after the `await` with no settling of its own (work asleep on the mocked clock waits for the test to advance it). The test's `classic` noun raises a classic hook event as the engine does (`SessionStart({ source: 'clear' })`, the envelope fields stamped unless given; every event but `PreToolUse`, which a test reaches through the `tool` noun's `call`). The kit exercises the plugin's hooks and the description they return under each surface's rules, not any surface's paint.

## Drawing: ui.render

A `ui.render` hook receives one component instance. `e.component` says
which component, `e.surface` where it is drawn (`terminal`, `desktop`,
`mobile` or `vscode`), `e.requestId` which instance (the tool_use_id for a tool row or
dialog, the message id for a message or a command's output row, the agent id for a spinner), `e.props`
the component's plain-data props, and `e.viewport`, when the surface has
measured, the size it draws into in character cells: `columns` and `rows`. A transcript message's `e.props.onScreen` says which of its rows the viewport shows now (`{ first, last, of }`, from the site's first laid-out row; `null` while off screen; absent where the surface does not say, as on the terminal's main screen), and the hook re-runs for that message when it changes.
A change of width re-runs every hooked site once the resize settles, so a
tree sized to `columns` stays right; a change of height alone re-draws
nothing. A `Pane` or `AbovePrompt` hook sizes its tree to `e.props.bodyColumns` instead: the box it draws into, which is narrower than the viewport while a pane is docked beside the transcript. `e.viewport.isFullscreen` says whether the surface docks a pane at all (the terminal's fullscreen layout does, its main screen opens one inline; absent where a surface does not say, so do not assume), the fact `command.run`'s `presentation` carries, so a plugin opens a pane unasked only where it would be a sidebar. `$.ui.invalidate` asks for a redraw
when the hook's own state changed.

Build trees from the table `$.ui.resolve(e)` returns: the surface's element constructors,
destructured into the hook's JSX tags (a module has no element globals). Tables differ per
surface, see `Elements` (`mobile` has no `Input`, `Select` or `Client`, `vscode` no `Client`,
`terminal` no `Svg` but alone `Raster` and `Image`); narrowing `e.surface` narrows the table. A grid of colored cells
(sparkline, heat map, rendered frame) is one `Raster`, its cells packed per `RasterProps`, never a `Box` per cell; `$.ui.blit`
repaints a mounted one without a render pass. A picture (PNG or RGBA bytes, or the name of a file or POSIX shared-memory object another local process wrote, per `ImageProps`) is one `Image` over a box of cells: the kitty graphics protocol where the terminal has it (kitty, Ghostty), its `alt` elsewhere or where the terminal cannot read this machine's files; a new source updates it in place, and a keyed one is swapped at the frame rate by `$.ui.blit({ requestId, key, source })`, the pixels never crossing `$`. Model-style text (headings, lists, tables, code fences, links; one outside `https:`/`http:`/`file:` draws as text) is one `Markdown`, drawn as an assistant reply is; given `key` and `onLinkPress`, a plain single click on a link it drew (any, or one `pressableLinks` names) raises `ui.press` carrying the link's `href` instead of the surface opening it, where the surface reports clicks (the fullscreen terminal; a ctrl- or alt-click still opens it). Return a
tree, or `next({ ...e, props })` to change what the engine draws, or `next(e)` to leave it.
A tree that does not validate (an element the surface lacks, a prop it does not take, a
child where none goes) is not drawn: the engine draws its own instead and writes to the
debug log a line beginning `ui.render (<Component>): a hook returned a tree that does not
validate`, followed by the reason. When a drawing silently falls back, that line and the
element's props type are the two things to read. A Button is `[ label ]` on the terminal, or with `plain` no brackets: `1: label` beside its `hotkey` and the label alone without one, so a one-glyph label is a one-glyph control the focus still inverts. Buttons, text fields and selects keep their
handlers in the plugin and raise `ui.press`, `ui.input` and `ui.select`; keys reach one only
while it has focus, Esc returns to the prompt; a Button's `hotkey` (one digit or lowercase letter) presses it while its site holds the keyboard, the band after ctrl+x tab or a click and a pane the same or opened with `focus`, except that a Button naming one of the engine's keybinding actions (`action: "app:cycleDiffBase"`) is also pressed by the person's chord for it from the prompt while it is mounted: chords, or a modified key Global or an active context binds, and not while an engine handler of that action is mounted. A pane opened with `focus`, `closeOnEscape` and `holdToasts` behaves as a dialog: it takes the keys, Tab and the arrows walk its buttons, Esc closes it, and toasts wait behind it; an element drawn `autoFocus` holds the ring from the start, every move of the ring is the `ui.focus` event first (its `element` the key now holding it, absent on the engine's close mark; `{ deny }` keeps it) and `$.ui.focus({ requestId, key })` moves it while the site holds the keys; `rows` opens it inline as tall as its content needs (up to what the layout spares, and the person's own size wins), so a short dialog shows whole and its arrows walk rather than scroll; the `command.run` input's `presentation` says whether the answer shows fullscreen and how wide the terminal is. A keyed `Box` scopes `hover` styles, a hover `scope` groups elements across sites, and a `Box` drawn `position: "absolute"` with cell offsets (`top: -2, left: 2`) paints over its surroundings without moving them, so `display: "none"` with `hover: { display: "flex" }` on it is a card that appears over the rows above a hovered glyph. Every user-role transcript row is the `UserMessage` site: the person's prompt, a background task's notification (`e.props.task`: its `id`, `status`, `durationMs`) and a message another agent, teammate, session or channel sent (`e.props.from.name`), told apart by `e.props.origin.kind`, which a matcher narrows on (`{ props: { origin: { kind: 'task-notification' } } }`); a hook that draws a compact row of its own returns `next(e)` while `e.props.isExpanded` (ctrl+o), so the full row still shows there, and a rewritten `text` changes the row alone, never what the model read. A slash command's output row is the `CommandOutput` site: a plugin whose command answers `command.run` with `{ text, context? }` (`text` the row the model also reads, `context` notes only the model reads, recorded after it) hooks it with `{ component: 'CommandOutput', props: { command: 'mine' } }` and draws that text as a tree inline in the transcript, where a built-in command's lines would sit.

## Work that outlives a dispatch

A hook runs inside one dispatch with a budget of its own time (a `next` or `$` call in flight does not count; a `$.clock.sleep` does, so a `turn.step` generator that polls with it pays every sleep from its one budget), and `next.signal` aborts
when that dispatch is abandoned (the user interrupted, another hook settled
first, the budget ran out); anything started for the dispatch should stop
on it. Work meant to outlive a dispatch belongs elsewhere: start it from a
`session.start` hook, which fires once when the session is ready and is
awaited before the first prompt (so a `$.tool.register` awaited there is
listed by turn one), and keep it going with `$.clock.every` and
`$.clock.after`, whose timers run until cancelled or until the module
reloads. `$.prompt.submit` queues a prompt that starts a turn of its own once the session is idle (never folded into a running turn; the call resolves as that turn starts, not when it ends), so
background work can wake a quiet session. `$.model.complete({ model, prompt })` runs one text completion with no history on the session's own client and always resolves a result (`ModelCompleteResult`), never a bare string and never a rejection over what the provider did: `isAnswered` with `text` and `usage` (a `ModelUsage`, the four token counts as the API spells them: the one shape `session.compact`'s result, `turn.complete`'s `usage` and the context breakdown's `apiUsage` report a call's cost in too), or `isAnswered: false` with a `reason`, `api-error` (with the HTTP `status` and the `error` kind, never the error's text), `empty-reply`, or `aborted` (its `timeoutMs` elapsed, or the dispatch that made the call was abandoned), `usage` on each arm; only a request the engine refuses to send (a blocked model, a bad `maxTokens`) rejects. `$.model.fork({ prompt })` asks one tool-less question over the session's own transcript as the main thread last sent it, same model and system prompt, so the API serves that prefix from its prompt cache (`usage.cache_read_input_tokens` says how much it served); its result is the same arms plus `nothing-to-fork` (a new session before its first turn, and again right after a /clear), its `aborted` the turn whose hook forked interrupted while the fork ran. `$.ui.status`, `$.ui.toast` and
`$.ui.log` show state without starting a turn, `$.ui.copy({ text, surface })` puts text on the clipboard of the surface the caller names (a press hook passes `e.surface`; left out, the session's first): the terminal's through the machine's clipboard tool and OSC 52, resolving `{ isCopied: true }`; `{ isCopied: false, reason }` on a remote surface, `no-clipboard`, or with nothing drawing, `no-surface`; the event `ui.copy` carries the target `surface`, so a hook may rewrite, refuse or take it), `$.store` keeps values
across sessions, and `$.process.run` runs a host command by argv. `$.fs` reads (text, or `{ as: 'bytes' }` for `{ base64 }`), writes, lists and stats paths; `$.fs.stat(path, { resolve: true })` also answers `realPath`, every symbolic link and `..` resolved (what `realpath` gives: a hard link, a `/.vol/` file-id spelling or a case alias keeps its own spelling), so a guard's robust form is an allow-list on `realPath` under a root it resolved the same way, and a deny-list on spellings is best effort.

## Tools and agent types the model can call

`$.tool.register` declares a tool: its name, the description the model
reads and its input schema; the tool is listed as `mcp__<plugin>__<name>`.
The plugin serves it by hooking `tool.call` with the matcher
`{ tool: 'mcp__<plugin>__<name>' }` and returning the result, and a call
no hook answers fails saying so. Registering the same name again replaces
the tool, and a plugin may register several, each listed as it lands. `$.agent.register` declares an agent type the same way, `<plugin>:<name>`, from an agent definition as settings JSON spells one (prompt, tools, model, and the rest, all in force); a plugin folder's `agents/*.md` files declare them too. `$.agent.spawn({ subagentType })` runs one and its answer is its `turn.complete`; an `agent.offer` hook returning `{ isOffered: false }` keeps it from the model while the plugin's own spawn still runs it.
