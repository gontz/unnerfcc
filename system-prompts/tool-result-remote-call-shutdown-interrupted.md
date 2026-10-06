<!--
name: 'Tool Result: Remote call interrupted by shutdown'
description: >-
  Warns that a command was interrupted by Claude Code shutdown on the remote
  machine and may have partially run.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
-->
The call was stopped while it ran because Claude Code on ${MACHINE_NAME} is shutting down — it may have partially run.
