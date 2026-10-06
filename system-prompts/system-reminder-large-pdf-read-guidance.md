<!--
name: 'System Reminder: Large PDF read guidance'
description: >-
  Warns that a PDF is too large to read at once and requires reading specific
  page ranges.
ccVersion: 2.1.292
variables:
  - READ_TOOL_NAME
-->
 You MUST use the ${READ_TOOL_NAME} tool with the pages parameter to read specific page ranges (e.g., pages: "1-5"). Do NOT call ${READ_TOOL_NAME} without the pages parameter or it will fail. 
