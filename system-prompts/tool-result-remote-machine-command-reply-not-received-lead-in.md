<!--
name: 'Tool Result: Remote machine connected but reply not received lead-in'
description: >-
  Lead-in explaining that the machine is connected but failed to return a
  command reply despite multiple checks.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
  - CHECK_COUNT
-->
${MACHINE_NAME} is still connected, but its reply to this command was not received (${CHECK_COUNT} checks about 
