<!--
name: 'Skill: /loop stop step and disarm monitor'
description: >-
  Step 6 instructions for cleanly stopping a loop by calling schedule_wakeup
  with stop:true and disarming any active monitor.
ccVersion: 2.1.292
variables:
  - SCHEDULE_WAKEUP_TOOL_NAME
  - TASK_STOP_TOOL_NAME
  - MONITOR_TOOL_NAME
  - TASK_LIST_TOOL_NAME
-->
. If the event means the work is finished, stop (step 6).
6. **To stop the loop** — the task is complete, further iterations can't make progress, or the user asked you to stop — call ${SCHEDULE_WAKEUP_TOOL_NAME} with `stop: true` (no other fields) and ${TASK_STOP_TOOL_NAME} any ${MONITOR_TOOL_NAME} you armed (use ${TASK_LIST_TOOL_NAME} to find the task ID if it is no longer in context).
