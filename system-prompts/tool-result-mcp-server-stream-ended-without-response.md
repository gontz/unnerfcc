<!--
name: 'Tool Result: MCP server stream ended without response'
description: >-
  Reports that an MCP server tool stream closed before answering, leaving the
  execution outcome unknown.
ccVersion: 2.1.292
variables:
  - MCP_SERVER_NAME
  - TOOL_NAME
-->
MCP server "${MCP_SERVER_NAME}" never answered tool "${TOOL_NAME}": the stream that was to bring its answer ended first. The outcome is unknown: the call may have finished, may still be running, or may never have started. Check what it did before you repeat it.
