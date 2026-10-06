<!--
name: 'System Reminder: Working directory no longer exists'
description: >-
  Warns that the session's working directory no longer exists and relative file
  paths or shell commands will fail.
ccVersion: 2.1.292
variables:
  - WORKING_DIRECTORY_PATH
-->
The session's working directory${WORKING_DIRECTORY_PATH} no longer exists; shell commands cannot start there and relative file paths that use it will fail until it is restored.
