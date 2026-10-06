<!--
name: 'Tool Result: Security refused changing Claude Code settings files'
description: >-
  Security error stating that Claude Code settings files cannot be modified from
  a cloud session.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
-->
${MACHINE_NAME} does not let a cloud session change its Claude Code settings files. Nothing was changed. Tell the user: those settings can only be changed on ${MACHINE_NAME} itself.
