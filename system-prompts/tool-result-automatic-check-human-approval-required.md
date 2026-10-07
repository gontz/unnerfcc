<!--
name: 'Tool Result: Human approval required on machine'
description: >-
  Tool result indicating that automatic approval is insufficient and direct
  human approval is required on the machine.
ccVersion: 2.1.292
variables:
  - TOOL_NAME
  - MACHINE_NAME
-->
This session's automatic check approved this ${TOOL_NAME} call, but only a person's approval counts for ${TOOL_NAME} on ${MACHINE_NAME}, so nothing ran. Retry once if it is still needed. If it is refused again, stop and tell the user that ${TOOL_NAME} on ${MACHINE_NAME} needs their own approval.
