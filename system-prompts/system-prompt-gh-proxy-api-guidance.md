<!--
name: 'System Prompt: GitHub API proxy guidance'
description: >-
  Instructs the model on using gh api flags, adhering to GitHub MCP tool
  preferences, and handling proxy 403 responses.
ccVersion: 2.1.292
-->
 (run `gh api --help` for its flags). This holds even if an earlier instruction in this prompt says you have no `gh` CLI or GitHub API access; where the prompt tells you to prefer GitHub MCP tools, keep preferring them. A 403 from the proxy says what this session lacks; retrying does not fix it.
