<!--
name: 'Tool Result: Remote call cancelled with approval pending'
description: >-
  Notice that a call was cancelled before starting while hooks or approvals were
  pending.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
-->
The call was cancelled on ${MACHINE_NAME} before the command started (a hook or an approval was still pending) — nothing ran.
