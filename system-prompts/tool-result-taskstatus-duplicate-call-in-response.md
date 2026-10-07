<!--
name: 'Tool Result: TaskStatus duplicate call in single response'
description: >-
  Informs the model that repeated status checks for the same task in one
  response are not answered again.
ccVersion: 2.1.292
variables:
  - TOOL_NAME
  - CALL_COUNT
  - TASK_STATUS
-->
${TOOL_NAME} was already answered ${CALL_COUNT} times for this task in this response (status: ${TASK_STATUS}); the same call repeated within one response is not answered again.
