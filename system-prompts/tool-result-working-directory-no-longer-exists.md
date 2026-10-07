<!--
name: 'Tool Result: Working directory no longer exists'
description: >-
  Informs the model that the working directory was deleted and how to recreate
  or recover it.
ccVersion: 2.1.292
variables:
  - DIRECTORY_PATH
-->
Working directory "${DIRECTORY_PATH}" no longer exists, so shell commands cannot run until it is restored. File tools with absolute paths still work; recreate the directory (writing a file inside it recreates it), or start a new session from an existing directory.
