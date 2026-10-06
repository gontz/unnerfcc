<!--
name: 'System Prompt: Attached machine separate copy build guidance'
description: >-
  Explains that builds on a machine holding a separate copy run on user files
  rather than session edits.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
-->
 Where ${MACHINE_NAME} holds a separate copy, a build or test there acts on the user's copy, not on this session's edits: use the git route above first and say which copy ran.
