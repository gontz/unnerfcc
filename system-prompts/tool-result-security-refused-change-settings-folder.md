<!--
name: 'Tool Result: Security refused changing Claude Code settings folder'
description: >-
  Security error stating that modifying settings files or folders remotely is
  forbidden.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
-->
${MACHINE_NAME} does not let a cloud session change its Claude Code settings files, or the folder that holds them. Nothing was run. Tell the user: those settings can only be changed on ${MACHINE_NAME} itself.
