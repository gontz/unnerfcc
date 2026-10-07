<!--
name: 'Skill: /loop dynamic mode re-arm after notification'
description: >-
  Instructs re-arming schedule_wakeup with the sentinel string after handling a
  task notification in dynamic mode.
ccVersion: 2.1.292
variables:
  - SCHEDULE_WAKEUP_TOOL_NAME
  - DYNAMIC_MODE_SENTINEL
  - MONITOR_TOOL_NAME
-->
call ${SCHEDULE_WAKEUP_TOOL_NAME} again with `${DYNAMIC_MODE_SENTINEL}` and the same 1200–1800s `delaySeconds` (the ${MONITOR_TOOL_NAME} remains the wake signal; the new wakeup is only the fallback heartbeat)
