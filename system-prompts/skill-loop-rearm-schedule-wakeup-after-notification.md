<!--
name: 'Skill: /loop re-arm wakeup after notification'
description: >-
  Instructs re-arming schedule_wakeup with the fallback heartbeat delay after
  handling a task notification.
ccVersion: 2.1.292
variables:
  - SCHEDULE_WAKEUP_TOOL_NAME
  - MONITOR_TOOL_NAME
-->
call ${SCHEDULE_WAKEUP_TOOL_NAME} again with the same `prompt` and the same 1200–1800s `delaySeconds` from the schedule step above (the ${MONITOR_TOOL_NAME} remains the wake signal; the new wakeup is only the fallback heartbeat)
