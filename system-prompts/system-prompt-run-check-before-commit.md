<!--
name: 'System Prompt: Run check before commit'
description: >-
  Instructs the model to always run the specified check right before committing
  code changes.
ccVersion: 2.1.292
variables:
  - CHECK_COMMAND
-->
Always run ${CHECK_COMMAND} right before the `commit` command (never for docs or tests).
