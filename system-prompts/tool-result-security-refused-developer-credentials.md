<!--
name: 'Tool Result: Security refused developer credentials access'
description: >-
  Security error stating that accessing SSH keys, cloud credentials, or saved
  developer logins is forbidden.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
  - PATH
-->
${MACHINE_NAME} does not let a cloud session read or change its SSH keys, cloud-provider credentials or saved developer-tool logins (${PATH}). Nothing was read or written.
