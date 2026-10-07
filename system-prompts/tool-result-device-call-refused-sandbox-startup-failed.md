<!--
name: 'Tool Result: Device call refused sandbox startup failed'
description: >-
  Error returned when device tools cannot run because sandboxing failed to start
  on the device.
ccVersion: 2.1.292
variables:
  - TOOL_NAME
-->
${TOOL_NAME} refused: sandboxing is enabled on this device but failed to start. Ask the user to run /sandbox on the device to see why, fix it, and restart Claude Code there; retrying before that will keep failing.
