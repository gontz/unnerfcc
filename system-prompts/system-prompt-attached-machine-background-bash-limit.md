<!--
name: 'System Prompt: Attached machine background Bash command limit'
description: >-
  Specifies the limit on background Bash commands running on the attached
  machine and detachment lifecycle.
ccVersion: 2.1.292
variables:
  - MAX_BACKGROUND_COMMANDS
-->
Up to ${MAX_BACKGROUND_COMMANDS} background Bash commands, stopped when this machine detaches.
