<!--
name: 'Data: Artifact publish scratchpad single call prefix'
description: >-
  Directs writing files to a scratchpad folder and publishing them in a single
  call.
ccVersion: 2.1.292
variables:
  - FIRST_FILE_PARAM
-->
Write the files at those relative paths under one folder in your scratchpad directory (or the working directory) and publish them in ONE call: ${FIRST_FILE_PARAM} every other file by its `project/…` path.
