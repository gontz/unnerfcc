<!--
name: 'Tool Result: Remote tool protocol version mismatch'
description: >-
  Error reporting protocol version mismatch between machines and advising
  updating Claude Code.
ccVersion: 2.1.292
variables:
  - TOOL_NAME
  - MACHINE_NAME
-->
${TOOL_NAME} on ${MACHINE_NAME} speaks a different remote tool execution protocol version than the caller. Update Claude Code on both machines.
