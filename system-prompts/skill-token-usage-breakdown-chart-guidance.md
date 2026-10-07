<!--
name: 'Skill: Token usage breakdown chart guidance'
description: >-
  Instructions for calculating effective token usage weighting, categorizing
  groups into a simple chart, and summarizing findings.
ccVersion: 2.1.292
variables:
  - SYSTEM_PROMPT_GROUP
  - USER_MESSAGES_GROUP
  - ASSISTANT_MESSAGES_GROUP
  - SUMMARY_GROUP
  - UNATTRIBUTED_TOOL_GROUP
  - SYSTEM_GROUP_NAME
  - USER_GROUP_NAME
  - ASSISTANT_GROUP_NAME
  - SUMMARY_GROUP_NAME
  - CHROME_GROUP_NAME
-->


`tokens` are the totals metered over `requests` requests. Effective usage weighs them: cache reads at about 0.1x, cache writes at about 2x, and output tokens at about 5x the cost of a regular input token. Each of `groups` has `percent`, its share of that, and `calls`, how many times the tool was called (0 where the group is no tool). `${SYSTEM_PROMPT_GROUP}` is the system prompt, the tool list, attached files and the other context that get re-read each turn. `${USER_MESSAGES_GROUP}` is what I wrote, `${ASSISTANT_MESSAGES_GROUP}` is your own replies and thinking, `${SUMMARY_GROUP}` is the summary of an earlier part of the conversation, and `${UNATTRIBUTED_TOOL_GROUP}` is tool use that could not be put down to one tool. Any other group is a tool, or `mcp__` and the name of the connector whose tools it adds up.

Make one simple chart, adding `percent` up into a few groups: Claude's instructions (`${SYSTEM_PROMPT_GROUP}`), the conversation itself (`${USER_MESSAGES_GROUP}`, `${ASSISTANT_MESSAGES_GROUP}` and `${SUMMARY_GROUP}`), Claude in Chrome (`${SYSTEM_GROUP_NAME}`), files and commands (`${USER_GROUP_NAME}` among them), connectors (the remaining `mcp__` groups, one per connector), web research (`${ASSISTANT_GROUP_NAME}` and `${SUMMARY_GROUP_NAME}`), subagents (`${CHROME_GROUP_NAME}`, whose `calls` is how many ran), and everything else. If a group is not present, skip it. If a connector's name looks like a random ID, call it by what it does.

Then give the totals in a line, and explain the chart clearly in everyday words without technical jargon. Close with these caveats:
