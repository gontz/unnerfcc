<!--
name: 'Tool Result: Remote machine reconnect wait suffix'
description: >-
  Suffix stating how long the session waited for a remote machine to return and
  to reuse it once reconnected.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
-->
 s for ${MACHINE_NAME} to come back; if this session is later told that ${MACHINE_NAME} is back, use it again from then.
