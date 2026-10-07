<!--
name: 'Tool Result: Remote call deadline reached with approval pending'
description: >-
  Notice that a call was stopped at its deadline while hooks or approvals were
  still pending.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
-->
The call was stopped on ${MACHINE_NAME} at its deadline before the command started (a hook or an approval was still pending) — nothing ran.
