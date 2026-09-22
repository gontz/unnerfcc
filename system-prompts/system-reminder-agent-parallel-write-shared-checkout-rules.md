<!--
name: 'System Reminder: Agent parallel write shared checkout rules'
description: >-
  Instructs a subagent running in a shared working directory to edit only
  required files and avoid overwriting other agents' changes.
ccVersion: 2.1.280
-->
Note: another write-capable agent is already running in this same working directory, and parallel agents sharing a checkout can overwrite each other's work. Edit only the files your task requires, re-read a file right before changing it, and do not revert or overwrite changes you did not make.
