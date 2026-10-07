<!--
name: 'Tool Result: MCP server connection closed message unparseable'
description: >-
  Informs the model that the connection to an MCP server closed due to an
  unparseable or oversized message.
ccVersion: 2.1.292
variables:
  - MCP_SERVER_NAME
  - TOOL_NAME
-->
The connection to MCP server "${MCP_SERVER_NAME}" was closed because a message from the server was too large or could not be parsed, so the result of tool "${TOOL_NAME}" was not read. The tool may have run: check whether it did before running it again.
