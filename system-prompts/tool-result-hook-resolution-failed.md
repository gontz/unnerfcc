<!--
name: 'Tool Result: Hook resolution failed'
description: >-
  Informs the model that Claude Code could not determine applicable hooks for
  the tool call.
ccVersion: 2.1.292
variables:
  - HOOK_TYPE
-->
Blocked: Claude Code could not work out which hooks apply to this call. Retry with a different input. If every call is blocked, check the ${HOOK_TYPE} hooks in /hooks or in your settings.
