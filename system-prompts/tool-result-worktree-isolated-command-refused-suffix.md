<!--
name: 'Tool Result: Worktree isolated command refused (suffix)'
description: >-
  Suffix refusing to run a command outside its isolated worktree and directing
  where to run it.
ccVersion: 2.1.292
variables:
  - AGENT_NAME
  - WORKTREE_PATH
-->
). Refusing to run it there — ${AGENT_NAME} commands must run inside its own worktree. Re-run the command from ${WORKTREE_PATH}.
