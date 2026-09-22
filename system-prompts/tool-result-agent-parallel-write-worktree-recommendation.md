<!--
name: 'Tool Result: Agent parallel write worktree recommendation'
description: >-
  Warns that another write-capable agent is running in the working directory and
  recommends worktree isolation.
ccVersion: 2.1.280
-->
Note: another write-capable agent is already running in this same working directory, and parallel agents sharing a checkout can overwrite each other's work. For parallel code-writing agents, dispatch each with isolation: "worktree".
