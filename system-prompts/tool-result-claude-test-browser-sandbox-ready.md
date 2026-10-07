<!--
name: 'Tool Result: Claude Test browser sandbox ready'
description: >-
  Tells the model that Chrome's sandbox is now available and instructs it to
  report BLOCKED and prompt the user to re-run.
ccVersion: 2.1.292
-->
Chrome's own sandbox can start here now, so the test browser can be started. Nothing to do: report BLOCKED "the test browser was not ready a moment ago: run /claude-test:run again" and end this run; the next run has the browser tools (no /mcp step). Do not use another browser.
