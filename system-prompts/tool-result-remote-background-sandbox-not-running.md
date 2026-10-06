<!--
name: 'Tool Result: Remote background sandbox not running'
description: >-
  Error stating background commands cannot start because the sandbox is enabled
  but not running on the target machine.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
-->
${MACHINE_NAME} has Claude Code's sandbox switched on, but the sandbox is not running there, so it starts no command in the background. Nothing was started.
