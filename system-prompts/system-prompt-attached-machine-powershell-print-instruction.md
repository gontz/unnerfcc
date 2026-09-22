<!--
name: 'System Prompt: Attached machine PowerShell print instruction'
description: Instructs printing file contents on the attached machine using Get-Content.
ccVersion: 2.1.280
variables:
  - TOOL_NAME
  - PARAM_FLAG
-->
print it there with Get-Content (${TOOL_NAME}, with "${PARAM_FLAG}")
