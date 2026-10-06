<!--
name: 'Tool Result: Remote machine disconnected retry guidance'
description: >-
  Guidance against retrying non-idempotent commands until remote machine
  reconnects.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
-->
. Do not retry non-idempotent commands on ${MACHINE_NAME} until ${MACHINE_NAME} reconnects, and do not call it again in this turn: do the rest of the task without ${MACHINE_NAME}, and tell the user what is blocked and what you could not verify. Check once more only when the user says it is back or asks you to try again.
