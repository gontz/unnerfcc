<!--
name: 'Tool Result: PreToolUse hook deferral unsupported'
description: >-
  Explains that a PreToolUse hook deferred a call, which is not supported in
  cloud sessions.
ccVersion: 2.1.292
variables:
  - HOOK_NAME
-->
A PreToolUse hook (${HOOK_NAME}) deferred this call; deferral is not supported for calls served to a cloud session, so nothing ran.
