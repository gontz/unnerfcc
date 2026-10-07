<!--
name: 'Tool Result: Remote machine answered call but answer not returned'
description: >-
  Notes that the remote machine answered a tool call but the answer could not be
  returned.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
  - REASON
  - FOLLOW_UP
-->
${MACHINE_NAME} answered this call, but the answer ${REASON}, so it was not returned.${FOLLOW_UP}
