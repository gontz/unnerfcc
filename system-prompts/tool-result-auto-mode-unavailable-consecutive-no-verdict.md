<!--
name: 'Tool Result: Auto mode unavailable consecutive no verdict'
description: >-
  Informs the model that auto mode is unavailable after consecutive safety
  verdict failures and the action was not run.
ccVersion: 2.1.280
variables:
  - CONSECUTIVE_FAILURE_COUNT
  - ACTION_NAME
-->
Auto mode is unavailable: the server returned no safety verdict for ${CONSECUTIVE_FAILURE_COUNT} responses in a row, so ${ACTION_NAME} was not run and this turn has ended. Wait for the user's next message before doing anything further.
