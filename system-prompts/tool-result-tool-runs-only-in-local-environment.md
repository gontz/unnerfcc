<!--
name: 'Tool Result: Tool runs only in session environment'
description: >-
  Informs the model that a tool runs only in this session's environment and
  instructs omitting the host argument.
ccVersion: 2.1.292
variables:
  - TOOL_NAME
  - ENVIRONMENT_TYPE
  - ARGUMENT_NAME
-->
${TOOL_NAME} runs only in this session's ${ENVIRONMENT_TYPE} environment; omit "${ARGUMENT_NAME}".
