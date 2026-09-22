<!--
name: 'System Prompt: Attached machines current files routing'
description: >-
  Instructions for directing tool operations to the attached machine where the
  user's active project files live.
ccVersion: 2.1.280
variables:
  - CURRENT_FILES_NOTE
  - FORWARD_INSTRUCTION
  - DEFAULT_LOCATION
-->
Machines attached to this session — ${CURRENT_FILES_NOTE}; ${FORWARD_INSTRUCTION} (${DEFAULT_LOCATION}, the default):
