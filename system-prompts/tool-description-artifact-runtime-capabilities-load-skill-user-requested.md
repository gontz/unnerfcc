<!--
name: 'Tool Description: Artifact runtime capabilities (user-requested skill load)'
description: >-
  Instructs loading the runtime capabilities skill before writing an artifact
  when requested capabilities require dynamic runtime features.
ccVersion: 2.1.292
variables:
  - RUNTIME_CAPABILITIES_SKILL
-->
**Runtime capabilities** (optional): depending on what is enabled for this user, a published page can do more than static HTML — read the user's live or connected data, remember what people do on it (a poll, a sign-up sheet, a checklist, a document edited in place — the page saves new versions of itself), keep state shared across viewers, know who is viewing, ask Claude a question of its own, store files people add, or hand the viewer a file to save — declared via the `capabilities` input. **Whenever the user asks for a page that needs any of that, you MUST load the `${RUNTIME_CAPABILITIES_SKILL}` skill BEFORE writing the artifact, and always before passing `capabilities` or writing any `window.claude.*` runtime code** — it tells you what's available to this user and how to use it. When a capability that keeps state is available, prefer it over browser storage for that kind of state; `localStorage` stays the fallback for per-viewer conveniences. Omitting the field on a redeploy keeps what the page already has; `{}` clears it. A page that saves new versions of itself 
