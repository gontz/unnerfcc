<!--
name: 'Tool Result: Security refused Mac keychain access'
description: >-
  Security error stating that the remote machine forbids cloud sessions from
  accessing macOS keychain files.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
  - PATH
-->
${MACHINE_NAME} does not let a cloud session open this Mac's keychain files (${PATH}). Nothing was read or written.
