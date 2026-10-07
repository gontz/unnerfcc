<!--
name: 'Tool Result: Device call refused sync setting changed'
description: >-
  Error returned when directory sync settings on the device changed, disabling
  device tool serving.
ccVersion: 2.1.292
variables:
  - TOOL_NAME
-->
${TOOL_NAME} refused: the user has since changed this directory's sync setting on their machine, so its files are no longer served through device tools in this session, and nothing was done. Tell the user; do not retry in a loop.
