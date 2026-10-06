<!--
name: 'Tool Result: Security refused changing connection credential'
description: >-
  Security error stating that the remote machine forbids cloud sessions from
  modifying connection authorization credential files.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
  - PATH
-->
${MACHINE_NAME} does not let a cloud session change the credential file that authorizes this connection (${PATH}). Nothing was written.
