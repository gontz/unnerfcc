<!--
name: 'Tool Result: Remote background task status check'
description: >-
  Explains how to check status and tail output of a remote background task using
  the designated tool.
ccVersion: 2.1.292
variables:
  - TASK_STATUS_TOOL
  - STATUS_TOOL_NAME
-->
To check on it, call ${TASK_STATUS_TOOL} with that ID: ${STATUS_TOOL_NAME} itself says whether it is still running, how it ended, and the end of its output.
