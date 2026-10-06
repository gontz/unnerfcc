<!--
name: 'Tool Result: Remote cloud sessions limit suffix'
description: >-
  Suffix advising that restarting Claude Code on the target machine frees
  session slots.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
-->
, the most it holds at once — this session was not added and nothing ran. Tell the user: restarting Claude Code on ${MACHINE_NAME} frees those seats. Do not retry in a loop.
