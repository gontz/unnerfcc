<!--
name: 'Skill: /loop task-notification wakeup handling'
description: Step 5 instruction for handling loop wakeups triggered by task notifications.
ccVersion: 2.1.292
variables:
  - CONFIRMATION_STEP
-->

${CONFIRMATION_STEP}
5. **If you were woken by a `<task-notification>`** rather than this prompt: handle the event in the context of the loop task, then make the same decision. If the loop should continue, 
