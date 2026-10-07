<!--
name: 'Tool Result: Security refused Credential Manager access'
description: >-
  Security error stating that the remote machine forbids cloud sessions from
  accessing Credential Manager files.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
  - PATH
-->
${MACHINE_NAME} does not let a cloud session open this computer's Credential Manager files (${PATH}). Nothing was read or written.
