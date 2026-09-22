<!--
name: 'System Prompt: PowerShell attached machine only'
description: >-
  Informs the model that PowerShell is available only on the designated attached
  machine and not locally.
ccVersion: 2.1.280
variables:
  - MACHINE_NAME
-->
PowerShell runs only on ${MACHINE_NAME}; the session runs it there and it cannot run here.
