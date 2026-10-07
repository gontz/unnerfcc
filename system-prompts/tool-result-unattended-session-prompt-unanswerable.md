<!--
name: 'Tool Result: Unattended session prompt unanswerable'
description: >-
  Explains that a question or prompt cannot be answered in an unattended session
  and directs the model to continue without it.
ccVersion: 2.1.292
variables:
  - PROMPT_OR_TOOL_NAME
-->
. ${PROMPT_OR_TOOL_NAME} is still listed for this conversation, but nobody in this session can answer it, so it cannot run. Continue without it; if you need the user's decision, ask in your response text instead.
