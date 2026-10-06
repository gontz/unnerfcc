<!--
name: 'System Reminder: Working directory changed'
description: >-
  Notifies the model that the working directory changed and tool calls,
  settings, MCP servers, and skills now resolve from the new path.
ccVersion: 2.1.292
variables:
  - NEW_WORKING_DIRECTORY
  - DIRECTORY_INFO
  - STALE_ENV_NOTE
-->
The session's working directory has changed to ${NEW_WORKING_DIRECTORY} (${DIRECTORY_INFO}). ${STALE_ENV_NOTE}All tool calls and relative paths now resolve from ${NEW_WORKING_DIRECTORY}. Project settings (permission rules, hooks), project MCP servers, and project skills now come from ${NEW_WORKING_DIRECTORY}; its CLAUDE.md, if any, follows below. Environment variables set by the previous directory's settings stay in effect for this process — they cannot be unset — and the new directory's settings env is applied on top of them.
