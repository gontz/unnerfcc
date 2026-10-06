<!--
name: 'Tool Result: Remote machine bridge unreachable details'
description: >-
  Informs that the target machine is not answering and directs retrying or
  asking the user to check Claude.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
-->
${MACHINE_NAME} is not answering right now — most often because Claude on it is not connected (the computer may be offline or asleep, or reconnecting after another session used it); the call did not run. Try again shortly, or ask the user to check that Claude is running on ${MACHINE_NAME}.
