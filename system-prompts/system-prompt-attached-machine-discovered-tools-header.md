<!--
name: 'System Prompt: Attached machine discovered tools header'
description: >-
  Header introducing tools discovered on the attached machine's PATH upon
  connection.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
-->
- Found on ${MACHINE_NAME} when it attached (looked up by name on its PATH, not run; 
