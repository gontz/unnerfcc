<!--
name: 'Tool Result: Security refused querying credential store'
description: >-
  Security error stating that the remote machine forbids cloud sessions from
  querying credential stores.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
  - COMMAND
-->
${MACHINE_NAME} does not let a cloud session query its credential store (`${COMMAND}`). Nothing was run.
