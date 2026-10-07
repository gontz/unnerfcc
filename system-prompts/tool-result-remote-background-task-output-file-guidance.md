<!--
name: 'Tool Result: Remote background task output file guidance'
description: >-
  Notes that the output file on the remote machine shows printed output but not
  execution status.
ccVersion: 2.1.292
variables:
  - READ_TOOL_NAME
  - MACHINE_PARAM_KEY
  - MACHINE_NAME
-->
Its output file there (${READ_TOOL_NAME} with ${MACHINE_PARAM_KEY}: "${MACHINE_NAME}") shows what it has printed, not whether it is still running.
