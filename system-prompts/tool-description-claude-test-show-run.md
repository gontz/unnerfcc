<!--
name: 'Tool Description: Claude Test show run'
description: >-
  Describes the tool that opens the live browser test run page in the user's
  default browser.
ccVersion: 2.1.292
-->
Open the live page of the run that is about to start in the person's default browser, so they can watch it. Call it from the person's conversation only, right before the runner is started, with livePageShow.arguments exactly as your own "ct.mjs new-run" printed them, nothing else. The page is a local file this browser helper wrote under the plugin's data folder. To open it the helper starts ONE program outside Claude Code's command sandbox (open, xdg-open or explorer.exe, from a fixed location) with that file's path and nothing else from the call (on a Mac, after the first time, -g before it, so it opens behind their work), at most once a run and eight times a session, and notes in the person's prefs.json, the first time, that a page has been opened. It opens nothing in CI, over SSH, with no display, with CLAUDE_TEST_NO_OPEN set, or when the person chose "link" ("ct.mjs prefs live-page link"). The answer says what became of it. A background run never calls this tool.
