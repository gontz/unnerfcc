<!--
name: 'Tool Result: Remote background command report header'
description: Header introducing a background command status report from a remote machine.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
  - TASK_ID
-->
[from ${MACHINE_NAME}, about background command ${TASK_ID}]
