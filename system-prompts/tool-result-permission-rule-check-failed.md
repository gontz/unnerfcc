<!--
name: 'Tool Result: Permission rule check failed on remote machine'
description: >-
  Error stating that permission rule evaluation could not complete on the remote
  machine.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
  - TOOL_NAME
-->
${MACHINE_NAME} could not finish checking its permission rules for this ${TOOL_NAME} call, so the call was not run and nobody was asked. Sending the same call again is unlikely to help. Tell the user: this is an error on ${MACHINE_NAME}, not a refusal by one of its rules.
