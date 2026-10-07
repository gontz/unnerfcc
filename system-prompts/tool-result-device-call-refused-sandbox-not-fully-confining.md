<!--
name: 'Tool Result: Device call refused sandbox not fully confining'
description: >-
  Error returned when the device sandbox is not fully isolating filesystem and
  network.
ccVersion: 2.1.292
variables:
  - TOOL_NAME
-->
${TOOL_NAME} refused: the sandbox on this device is not fully confining (filesystem and network). Ask the user to set "sandbox": {"enabled": true, "filesystem": {"disabled": false}} in Claude Code settings on the device and not to run it in subprocess-env-scrub mode; do not retry until they have.
