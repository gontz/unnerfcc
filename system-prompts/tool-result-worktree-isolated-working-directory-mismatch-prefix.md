<!--
name: 'Tool Result: Worktree isolated working directory mismatch (prefix)'
description: >-
  Prefix warning that a command's working directory is outside its isolated
  worktree.
ccVersion: 2.1.292
variables:
  - AGENT_OR_TASK_NAME
  - WORKTREE_PATH
-->
${AGENT_OR_TASK_NAME} is isolated in the worktree ${WORKTREE_PATH}, but this command's working directory (
