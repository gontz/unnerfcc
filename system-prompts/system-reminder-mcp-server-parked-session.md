<!--
name: 'System Reminder: MCP server did not start parked session'
description: >-
  Informs that an stdio MCP server did not start because the session is parked
  until claimed by a host.
ccVersion: 2.1.292
variables:
  - MCP_SERVER_NAME
-->
The MCP server "${MCP_SERVER_NAME}" did not start: this session is parked until a host claims it, and its stdio servers start at the claim.
