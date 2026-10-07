<!--
name: 'Tool Result: Unsandboxed execution not available'
description: >-
  Informs that unsandboxed execution is unavailable in the current agent
  context.
ccVersion: 2.1.292
variables:
  - AGENT_TYPE
-->
unsandboxed execution (dangerouslyDisableSandbox) is not available to ${AGENT_TYPE}. If the command failed with a sandbox violation, the operation cannot be performed in this context — do not retry it.
