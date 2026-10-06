<!--
name: 'Tool Result: Artifact capabilities MCP empty servers refused'
description: >-
  Explains that capabilities.mcp cannot have an empty servers list and details
  valid configuration syntax.
ccVersion: 2.1.292
-->
capabilities.mcp declares no servers — put one {"server": "<connector name>", "tools": ["<tool name>", ...]} entry under "servers" for each connector the page calls; to publish without connector access leave "mcp" out of capabilities (pass capabilities: {} to clear a stored declaration) — an empty "servers" list is refused
