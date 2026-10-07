<!--
name: 'Tool Result: Background task ID not found'
description: >-
  Informs the model that no background command was found with the specified task
  ID.
ccVersion: 2.1.292
variables:
  - TASK_ID
-->
No background command with task ID ${TASK_ID}. Task IDs come from the {"resultType":"task", …} result that moved a command to the background, and finished commands are remembered for this session only.
