<!--
name: 'Tool Result: Next Wakeup Scheduled'
description: >-
  Snooze/wakeup tool result: confirms the next wakeup time; nothing more to do
  this turn, harness re-invokes on wakeup or task notification.
ccVersion: 2.1.292
variables:
  - WAKEUP_TIME
  - DELAY_SECONDS
  - DETAILS
  - POST_SCHEDULE_INSTRUCTION
-->
Next wakeup scheduled for ${WAKEUP_TIME} (in ${DELAY_SECONDS}s)${DETAILS}. ${POST_SCHEDULE_INSTRUCTION}
