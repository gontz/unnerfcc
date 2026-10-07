<!--
name: 'Agent Prompt: Batch non-git worktree guidance'
description: >-
  Instructions for batch worker orchestration when worktrees come from hooks in
  non-git repositories.
ccVersion: 2.1.292
-->

## Version control

This directory is not a git repository: worker worktrees come from a WorktreeCreate hook, so `isolation: "worktree"` works as above, but git and `gh` commands do not. Say so in every worker prompt, and when you copy the worker instructions, replace step 4 with: commit and publish the change with this project's own version-control commands, and end with `PR: none — <what was published instead>` when no pull request can be opened. In Phase 3, a worker that reports what it published instead of a PR URL counts as done; show that report in the PR column.
