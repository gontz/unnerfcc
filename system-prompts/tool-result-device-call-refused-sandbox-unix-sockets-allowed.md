<!--
name: 'Tool Result: Device call refused sandbox unix sockets allowed'
description: >-
  Error returned when device tools are refused because Unix socket connections
  are allowed in the sandbox.
ccVersion: 2.1.292
variables:
  - TOOL_NAME
-->
${TOOL_NAME} refused: the sandbox on this device allows connections to Unix sockets (sandbox.network.allowAllUnixSockets or allowUnixSockets), through which a command could reach services running outside the sandbox, so this device serves no device tools. Tell the user; do not retry in a loop.
