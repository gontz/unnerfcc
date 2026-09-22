<!--
name: 'Tool Result: Auto mode unavailable consecutive no verdict for agent'
description: >-
  Informs the model that auto mode is unavailable after consecutive safety
  verdict failures and that the subagent was stopped.
ccVersion: 2.1.280
variables:
  - CONSECUTIVE_FAILURE_COUNT
-->
Auto mode is unavailable: the server returned no safety verdict for ${CONSECUTIVE_FAILURE_COUNT} responses in a row, so this agent was stopped before it finished. Nobody interrupted it; whatever it returned is partial. Retrying now will likely stop the same way — wait for the user's next message.
