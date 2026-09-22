<!--
name: 'Tool Result: Machine detached nowhere to run'
description: >-
  Informs the model that the requested machine detached and no available
  environment can run the tool.
ccVersion: 2.1.280
variables:
  - MACHINE_NAME
  - TOOL_NAME
-->
${MACHINE_NAME} is no longer attached to this session, and this session's own environment has no ${TOOL_NAME}: there is nowhere to run it until a computer that serves ${TOOL_NAME} attaches again. Nothing ran; do not retry it 
