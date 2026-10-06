<!--
name: 'Tool Result: Security refused reading connection credential'
description: >-
  Security error stating that the remote machine forbids cloud sessions from
  reading connection authorization credentials.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
  - PATH
-->
${MACHINE_NAME} does not let a cloud session read the credential that authorizes this connection (${PATH}). Nothing was read.
