<!--
name: 'Tool Parameter: Machine runs on primary environment'
description: >-
  Explains that the session environment lacks the tool, which runs on the
  specified machine.
ccVersion: 2.1.280
variables:
  - TOOL_NAME
  - PRIMARY_MACHINE_NAME
  - MACHINE_PARAM
-->
 — this session's own environment has no ${TOOL_NAME}; it runs on ${PRIMARY_MACHINE_NAME}: omit "${MACHINE_PARAM}" or set it to "${PRIMARY_MACHINE_NAME}".
