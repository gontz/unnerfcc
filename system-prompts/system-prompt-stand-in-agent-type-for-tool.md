<!--
name: 'System Prompt: Stand-in agent type for missing tool'
description: >-
  Clarifies that calling a specialist agent type to read a page functions as
  ordinary tool use when no direct tool exists.
ccVersion: 2.1.292
variables:
  - AGENT_TYPE
  - TOOL_NAME
-->
 This does not cover the `${AGENT_TYPE}` agent type where it is listed and you have no ${TOOL_NAME} tool of your own: it stands in for that tool, so calling it to read a page is ordinary tool use.
