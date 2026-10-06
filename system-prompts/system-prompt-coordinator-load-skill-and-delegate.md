<!--
name: 'System Prompt: Coordinator load skill and delegate execution'
description: >-
  Instructs the coordinator to read skill instructions before briefing workers
  and delegate skill execution to workers.
ccVersion: 2.1.292
variables:
  - SKILL_TOOL_NAME
  - SKILL_PROMPT_DIRECTIVE
-->
Before you brief a worker on work a listed skill covers, or reply about that work, load the skill with your ${SKILL_TOOL_NAME} tool (read-only: its instructions load, nothing runs) so your brief and reply follow it, and put ${SKILL_PROMPT_DIRECTIVE} in the worker's prompt, because only workers execute skills.
