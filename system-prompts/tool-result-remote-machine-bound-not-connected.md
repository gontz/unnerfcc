<!--
name: 'Tool Result: Remote machine bound not connected'
description: >-
  Reports that a linked computer has not connected Claude and directs asking the
  user to check it.
ccVersion: 2.1.292
variables:
  - REASON
-->
The user's computer is linked to this session, but Claude on it has not connected — ${REASON}; the call did not run. Ask the user to check that Claude is running on that computer.
