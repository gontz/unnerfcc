<!--
name: 'Tool Description: Artifact theme-aware styling'
description: >-
  Rules for supporting light, dark, and system color themes with CSS tokens in
  published artifacts.
ccVersion: 2.1.280
-->
**Theme-aware**: Pages render in the viewer's theme, which has three states: an explicit choice stamps `data-theme="dark"` / `data-theme="light"` on the root element, and the default "system" setting stamps nothing — only `prefers-color-scheme` separates light from dark. Define the complete light palette as tokens on bare `:root` (dark-first designs swap the roles consistently); redefine only the tokens under `@media (prefers-color-scheme: dark)`, guarded as `:root:not([data-theme="light"])`; redefine them again under `:root[data-theme="dark"]` so the toggle wins in both directions, and set `color-scheme: dark` wherever the dark palette applies — both dark blocks, or bare `:root` in a dark-first or single-dark design (the skeleton pins `light` on `:root`) — so form controls and scrollbars follow. Never give a color its only definition inside a media or `[data-theme]` block, and give `body` an explicit token background — the viewer paints its own ground behind the page, so a transparent body borrows the host's theme. A design that deliberately commits to a single look may skip the dark blocks but still paints background and colors explicitly.
