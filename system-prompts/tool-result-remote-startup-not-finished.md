<!--
name: 'Tool Result: Remote Claude Code startup not finished'
description: >-
  Notice that Claude Code on the remote machine timed out loading hooks and
  settings during startup.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
-->
Claude Code on ${MACHINE_NAME} has only just started and had not finished loading the hooks and settings it checks every call against before this call's time ran out — nothing ran. Send the call again in a moment. If it is refused this way again, tell the user that Claude Code on ${MACHINE_NAME} is not finishing its start-up.
