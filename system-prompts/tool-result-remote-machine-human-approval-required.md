<!--
name: 'Tool Result: Remote machine human approval required'
description: >-
  Advises retrying once and asking the user for their direct approval if refused
  again.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
-->
Retry once if it is still needed. If it is refused again, stop and tell the user that this tool on ${MACHINE_NAME} needs their own approval.
