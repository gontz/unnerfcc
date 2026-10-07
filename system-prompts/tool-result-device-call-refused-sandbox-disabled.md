<!--
name: 'Tool Result: Device call refused sandbox disabled'
description: >-
  Error returned when device tools are refused because sandboxing is disabled on
  the device.
ccVersion: 2.1.292
variables:
  - TOOL_NAME
-->
${TOOL_NAME} refused: sandboxing is not enabled on this device, and device tools are only served from a machine whose Claude Code sandbox is on. Ask the user to set "sandbox": {"enabled": true} in Claude Code settings on the device (check with /sandbox); do not retry until they have.
