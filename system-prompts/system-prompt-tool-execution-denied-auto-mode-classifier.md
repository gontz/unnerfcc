<!--
name: 'System Prompt: Auto-mode classifier action denied'
description: >-
  Tool_result returned when the auto-mode permission classifier denies an
  action, telling the model it may continue independent tasks
ccVersion: 2.1.292
variables:
  - DENIED_ACTION_DESCRIPTION
  - DENIAL_REASON
-->
${DENIED_ACTION_DESCRIPTION} ${DENIAL_REASON} If this was a batch or range operation, you may re-run it without the flagged items, but do not then act on the flagged items separately — leave those for the user. If this denial names something that would clear it — for example a first-hand read that shows the missing source — doing that is not pursuing the denied outcome: do it, and if it shows what the denial asked for, you may redo the action citing it.
