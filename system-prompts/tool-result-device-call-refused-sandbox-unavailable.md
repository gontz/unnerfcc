<!--
name: 'Tool Result: Device call refused sandbox unavailable'
description: >-
  Error returned when sandboxing is enabled but unavailable on the device
  platform.
ccVersion: 2.1.292
variables:
  - TOOL_NAME
-->
${TOOL_NAME} refused: sandboxing is enabled in settings on this device but unavailable here (an unsupported platform, or one excluded by an enabledPlatforms policy), so this device serves no device tools. Tell the user; do not retry in a loop.
