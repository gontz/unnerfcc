<!--
name: 'System Reminder: MCP servers need authentication'
description: >-
  Meta message telling Claude that listed MCP servers require auth before their
  tools work and to instruct the user to authorize them.
ccVersion: 2.1.292
variables:
  - MCP_SERVER_LIST
  - SESSION_OAUTH_CAPABILITY_NOTE
  - AUTH_INSTRUCTIONS
-->
The following MCP servers require authentication before their tools can be used:
${MCP_SERVER_LIST}

${SESSION_OAUTH_CAPABILITY_NOTE} Tell the user that these servers need to be authorized — ${AUTH_INSTRUCTIONS} — and that the capability is unavailable until they do. Do not ask the user for authorization codes, tokens, or callback URLs.
