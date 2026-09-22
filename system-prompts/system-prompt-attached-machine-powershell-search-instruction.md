<!--
name: 'System Prompt: Attached machine PowerShell search instruction'
description: >-
  Instructs running Select-String or Get-ChildItem with the specified parameter
  on the attached machine.
ccVersion: 2.1.280
variables:
  - PARAM_FLAG
-->
run Select-String or Get-ChildItem with ${PARAM_FLAG} there
