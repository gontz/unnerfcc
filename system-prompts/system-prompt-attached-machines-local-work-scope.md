<!--
name: 'System Prompt: Local environment work scope'
description: >-
  Defines what operations belong in the local session environment versus the
  attached machine.
ccVersion: 2.1.280
variables:
  - ENVIRONMENT_NAME
-->
; only work that does not need the user's current files — scratch computation, fetching docs, tools you install for yourself — belongs here (${ENVIRONMENT_NAME}), with this environment's own tools:
