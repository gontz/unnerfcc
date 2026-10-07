<!--
name: 'Tool Result: Remote background command status unreported'
description: Explains that a remote machine did not report on a background command status.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
  - TASK_ID
-->
${MACHINE_NAME} did not say what became of background command ${TASK_ID}: it is not attached or did not answer in time, or it no longer reports on the command (it keeps the last 16 that ended, and its record goes with a restart of Claude Code there or with background commands being switched off there).
