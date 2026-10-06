<!--
name: 'Tool Result: Remote server check failed clause'
description: >-
  Clause indicating the remote machine could not verify if it still serves this
  session.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
-->
when ${MACHINE_NAME} could not check whether it still serves this session
