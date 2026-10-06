<!--
name: 'Tool Result: Artifact capabilities MCP dynamic boolean requirement'
description: >-
  Specifies that capabilities.mcp dynamic must be a boolean true and explains
  dynamic server access.
ccVersion: 2.1.292
-->
capabilities.mcp "dynamic" must be the JSON boolean true (or left out) — no other value is accepted, a string or a number included; with "dynamic": true the page may call connectors the declaration does not list, and "servers" may then be empty
