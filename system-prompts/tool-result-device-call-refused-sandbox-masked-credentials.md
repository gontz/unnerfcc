<!--
name: 'Tool Result: Device call refused sandbox masked credentials'
description: >-
  Error returned when device tools are refused because the sandbox injects
  masked real credentials.
ccVersion: 2.1.292
variables:
  - TOOL_NAME
-->
${TOOL_NAME} refused: this device's sandbox is configured to inject real credentials into sandboxed network requests (sandbox.credentials entries with mode "mask"), so this device serves no device tools. Tell the user; do not retry in a loop.
