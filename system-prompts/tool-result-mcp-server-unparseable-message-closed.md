<!--
name: 'Tool Result: MCP server unparseable message connection closed'
description: >-
  Informs that an MCP server sent an unparseable or oversized message resulting
  in a closed connection and no result.
ccVersion: 2.1.292
variables:
  - MCP_SERVER_NAME
-->
MCP server ${MCP_SERVER_NAME} sent a message that was too large or could not be parsed, so Claude Code closed the connection and this mcp_call got no result. The server may have run the tool, so check whether the call took effect before retrying mcp_call.
