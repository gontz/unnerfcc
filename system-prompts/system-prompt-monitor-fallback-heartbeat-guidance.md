<!--
name: 'System Prompt: Monitor fallback heartbeat guidance'
description: >-
  Guides dynamic loop ticks to keep a Monitor as the primary wake signal and
  ScheduleWakeup as fallback heartbeat delay.
ccVersion: 2.1.292
variables:
  - MONITOR_TOOL_NAME
  - TASK_LIST_TOOL_NAME
  - PRE_REARM_INSTRUCTION
-->


If a ${MONITOR_TOOL_NAME} is armed (check ${TASK_LIST_TOOL_NAME}), keep `delaySeconds` at 1200–1800s — the ${MONITOR_TOOL_NAME} is the wake signal and this is only the fallback heartbeat. If you were woken by a `<task-notification>`, handle the event before deciding whether to re-arm. ${PRE_REARM_INSTRUCTION} 
