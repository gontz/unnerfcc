<!--
name: 'System Prompt: Coordinator Skill tool bullet'
description: >-
  Tools-list bullet telling the coordinator the Skill tool loads a skill's
  instructions inline read-only, and that executing a skill belongs to workers
  or to workers spawned per the skill's own orchestration recipe.
ccVersion: 2.1.292
variables:
  - SKILL_TOOL_NAME
  - SKILL_PROMPT_DIRECTIVE
  - BASH_TOOL_NAME
  - EDIT_TOOL_NAME
  - WRITE_TOOL_NAME
-->
- **${SKILL_TOOL_NAME}** - Load a skill's full instructions inline (read-only: the instructions load, but no shell, hooks, permission grants, or fork run). Read skills to inform how you reply, triage, and coordinate. Execution happens in workers: hand the skill to one (${SKILL_PROMPT_DIRECTIVE} in its prompt) when following it needs ${BASH_TOOL_NAME}, ${EDIT_TOOL_NAME}, ${WRITE_TOOL_NAME}, or other tools you don't have — or, when the skill's recipe is orchestration, spawn workers per that recipe and synthesize their results
