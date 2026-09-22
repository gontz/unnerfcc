<!--
name: 'Tool Parameter: Runs on machine with or without flag'
description: >-
  Notes that the tool runs on the specified machine whether or not the flag is
  explicitly provided.
ccVersion: 2.1.280
variables:
  - MACHINE_NAME
  - MACHINE_PARAM
-->
runs on ${MACHINE_NAME} with or without "${MACHINE_PARAM}"
