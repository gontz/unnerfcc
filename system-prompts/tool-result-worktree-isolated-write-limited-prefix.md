<!--
name: 'Tool Result: Worktree isolated write limited (prefix)'
description: >-
  Prefix explaining that writes from an isolated worktree cannot target a path
  in a different worktree.
ccVersion: 2.1.292
variables:
  - AGENT_OR_TASK_NAME
  - WORKTREE_PATH
-->
${AGENT_OR_TASK_NAME} is isolated in the worktree ${WORKTREE_PATH}, so its writes are limited to that folder. This path is in a different worktree (
