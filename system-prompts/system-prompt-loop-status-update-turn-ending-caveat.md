<!--
name: 'System Prompt: Loop status update turn ending caveat'
description: >-
  Explains that the turn ends immediately when schedule wakeup returns,
  precluding post-call messages.
ccVersion: 2.1.292
-->
When this call is your only tool call, the turn ends when it returns — there is no post-arm slot for a status update, so 
