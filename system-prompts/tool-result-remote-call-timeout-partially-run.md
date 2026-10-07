<!--
name: 'Tool Result: Remote call timeout partially run warning'
description: >-
  Warns that a remote command timed out and may have partially executed,
  advising against blind retries.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
-->
The call did not finish within its deadline on ${MACHINE_NAME} and was stopped — it may have partially run. Do not retry non-idempotent commands blindly.
