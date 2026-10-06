<!--
name: 'Tool Description: Read JSON single line chunking guidance'
description: >-
  Explains that line-based offset/limit chunking does not split single-line JSON
  and suggests using shell tools.
ccVersion: 2.1.292
variables:
  - READ_TOOL_NAME
  - SHELL_RECOMMENDATION
-->
- Note: this file is JSON, so a long value (or the whole file) is a single line. ${READ_TOOL_NAME}'s offset/limit cannot split a line, so reading in chunks works only if every line is short. If a shell tool is available, ${SHELL_RECOMMENDATION}.
