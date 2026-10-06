<!--
name: 'System Prompt: Loop status update and end turn guidance'
description: Guides emitting a status update if owed and ending the turn.
ccVersion: 2.1.292
variables:
  - STATUS_UPDATE_INSTRUCTION
-->
If you owe the user a status update this tick, ${STATUS_UPDATE_INSTRUCTION}; then end the turn — the harness re-invokes you when the wakeup fires or a task-notification arrives.
