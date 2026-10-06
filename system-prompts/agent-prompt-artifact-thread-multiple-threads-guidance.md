<!--
name: 'Agent Prompt: Artifact thread multiple threads guidance'
description: >-
  Instructs the background comment agent on handling additional threads marked
  awaiting reply.
ccVersion: 2.1.292
variables:
  - THREAD_MARKER
-->
 If a read shows another thread marked "${THREAD_MARKER}" with a comment marked sent to you and awaiting a reply, that one is yours as well: answer it after this one.
