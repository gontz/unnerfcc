<!--
name: 'System Prompt: Stop loop and monitor guidance'
description: >-
  Instructs stopping the dynamic loop via ScheduleWakeup stop:true and
  terminating the monitor.
ccVersion: 2.1.292
variables:
  - SCHEDULE_WAKEUP_TOOL_NAME
  - TASK_STOP_TOOL_NAME
  - TASK_LIST_TOOL_NAME
-->
 To stop the loop, call ${SCHEDULE_WAKEUP_TOOL_NAME} with `stop: true` and ${TASK_STOP_TOOL_NAME} the monitor (use ${TASK_LIST_TOOL_NAME} to find its task ID if no longer in context).
