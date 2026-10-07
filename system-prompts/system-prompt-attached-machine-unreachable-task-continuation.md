<!--
name: 'System Prompt: Unreachable machine task continuation'
description: >-
  Directs continuing tasks that do not require the unreachable machine and
  informing the user what is waiting.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
-->
. Do not call ${MACHINE_NAME}. Do everything in the task that does not need ${MACHINE_NAME}, here, in this turn; then, if anything is waiting on ${MACHINE_NAME}, tell the user 
