<!--
name: 'Tool Result: Device call refused sandbox missing seccomp'
description: >-
  Error returned when the device sandbox cannot enforce Unix socket blocking due
  to missing seccomp helpers.
ccVersion: 2.1.292
variables:
  - TOOL_NAME
-->
${TOOL_NAME} refused: the sandbox on this device cannot block connections to Unix sockets because the sandbox runtime found no seccomp filter helper it could run, so a command could reach services running outside the sandbox, and this device serves no device tools. Ask the user to open /sandbox on the device (its Dependencies tab shows the seccomp filter's status) and restart Claude Code there once it is fixed; do not retry until they have.
