<!--
name: 'System Prompt: Send update before scheduling wakeup tool'
description: >-
  Instructs the model to output its update before calling the schedule wakeup
  tool because the turn ends immediately on return.
ccVersion: 2.1.292
variables:
  - SCHEDULE_WAKEUP_TOOL_NAME
-->
 it immediately BEFORE calling ${SCHEDULE_WAKEUP_TOOL_NAME} — on this model the turn ends as soon as that tool returns, so an update after the call never goes out.
