<!--
name: 'System Reminder: Container restarted background work lost'
description: >-
  System reminder informing that background work was lost due to a container
  restart.
ccVersion: 2.1.292
variables:
  - BACKGROUND_WORK_LIST
  - RECOVERY_INSTRUCTION
-->
The container running this session was restarted before background work reported back: ${BACKGROUND_WORK_LIST}. ${RECOVERY_INSTRUCTION} if still needed (a long-running server or watcher that nothing is waiting on does not need restarting now), or tell the user what was lost.
