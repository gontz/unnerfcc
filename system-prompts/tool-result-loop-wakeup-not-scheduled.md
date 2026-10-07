<!--
name: Loop wakeup-not-scheduled tool_result
description: >-
  The tool_result content returned to the model when a /loop wakeup is not
  scheduled; model-facing.
ccVersion: 2.1.292
variables:
  - STOP_MONITOR_INSTRUCTION
-->
Wakeup not scheduled. The loop reached its maximum duration — the loop has ended; do not re-issue. ${STOP_MONITOR_INSTRUCTION}
