<!--
name: 'Tool Result: Proceed without unreachable remote machine'
description: >-
  Instructs proceeding with tasks that do not require the unreachable remote
  machine.
ccVersion: 2.1.292
variables:
  - ERROR_PREFIX
  - MACHINE_NAME
-->
${ERROR_PREFIX} Do not call ${MACHINE_NAME} again in this turn: do the rest of the task without ${MACHINE_NAME}, and tell the user what is blocked. Check once more only when the user says it is back or asks you to try again.
