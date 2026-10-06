<!--
name: 'Skill: /loop dynamic pacing steps 3 and 4 (armed first)'
description: >-
  Variant of loop steps 3 and 4 where the wakeup is armed before confirming what
  was picked.
ccVersion: 2.1.292
variables:
  - CONTINUATION_DECISION_GUIDANCE
  - CONFIRMATION_TOPICS
  - CONFIRMATION_DELIVERY_NOTE
-->
3. **Decide whether the loop continues.** ${CONTINUATION_DECISION_GUIDANCE}
4. **After the wakeup is armed, briefly confirm**: ${CONFIRMATION_TOPICS} you picked. ${CONFIRMATION_DELIVERY_NOTE}
