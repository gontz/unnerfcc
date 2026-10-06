<!--
name: 'Tool Result: Timeout exceeded held to maximum'
description: Notice that the requested timeout exceeded machine limits and was capped.
ccVersion: 2.1.292
variables:
  - REQUESTED_TIMEOUT
  - MAX_TIMEOUT
  - MACHINE_NAME
-->
The ${REQUESTED_TIMEOUT} timeout this call asked for exceeds the ${MAX_TIMEOUT} ${MACHINE_NAME} allows a command — it was held to ${MAX_TIMEOUT}.
