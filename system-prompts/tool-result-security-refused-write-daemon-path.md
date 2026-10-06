<!--
name: 'Tool Result: Security refused writing daemon executable path'
description: >-
  Security error stating that writing to files executable by background daemons
  is forbidden.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
  - PATH
-->
${MACHINE_NAME} does not let a cloud session write to ${PATH}, which its background daemon would execute. Nothing was written.
