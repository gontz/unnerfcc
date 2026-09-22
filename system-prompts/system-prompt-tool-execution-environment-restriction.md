<!--
name: 'System Prompt: Tool execution environment restriction'
description: >-
  States that calls to the specified tool execute in the remote environment and
  never locally.
ccVersion: 2.1.280
variables:
  - TOOL_NAME
  - RUN_LOCATION
-->
a ${TOOL_NAME} call ${RUN_LOCATION}, never here — this environment has none
