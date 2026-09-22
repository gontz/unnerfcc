<!--
name: 'Tool Result: Running tool on machine unavailable'
description: >-
  Informs the model that running the tool on the specified machine is
  unavailable and nothing ran.
ccVersion: 2.1.280
variables:
  - TOOL_NAME
  - MACHINE_NAME
-->
Running ${TOOL_NAME} on ${MACHINE_NAME} is not available in this session right now, and this session's own environment has no ${TOOL_NAME}; it did not run.
