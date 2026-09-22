<!--
name: 'System Reminder: Moving work between machine checkouts via git'
description: >-
  Protocol for moving work between session and attached machine checkouts
  through git branches.
ccVersion: 2.1.280
variables:
  - MACHINE_NAME
-->
- Moving work between the two copies goes through git, and only when the folder on ${MACHINE_NAME} is a checkout of the same repository. Commit here and push a branch from here (git push origin <branch>). Then on ${MACHINE_NAME}, as 
