<!--
name: 'Tool Result: Remote machine unanswered do not retry in turn'
description: >-
  Informs that the target machine is not answering and instructs not to call it
  again in this turn.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
-->
${MACHINE_NAME} is not answering right now — most often because Claude on it is not connected (the computer may be offline or asleep, or reconnecting after another session used it); the call did not run. Do not call ${MACHINE_NAME} again in this turn: do the rest of the task without ${MACHINE_NAME}, and tell the user what is blocked and to check that Claude is running on ${MACHINE_NAME}. Check once more only when the user says it is back or asks you to try again.
