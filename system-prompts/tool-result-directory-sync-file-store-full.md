<!--
name: 'Tool Result: Directory sync file store full'
description: >-
  Informs the model that changed files stay on the remote machine because the
  session file store is full.
ccVersion: 2.1.280
variables:
  - MACHINE_NAME
  - TOOL_NAME
-->
Directory sync: anything that command changed stays on ${MACHINE_NAME}: this session's file store is full, so nothing more can be uploaded to it for now; read what you need there with ${TOOL_NAME} on ${MACHINE_NAME}.
