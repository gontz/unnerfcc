<!--
name: 'Tool Description: SearchPlugins extended guidance'
description: >-
  Extended guidance and task-based examples for proactively calling
  SearchPlugins.
ccVersion: 2.1.280
variables:
  - TOOL_DESCRIPTION
  - EXAMPLES_HEADER
  - RETURN_GUIDANCE
-->
${TOOL_DESCRIPTION} The user does not need to name a plugin: search when the task depends on their team's own process, systems or data and nothing you already have, the project's own scripts included, covers it.

${EXAMPLES_HEADER}
- "ship this to staging" → keywords ["deploy", "release", "staging"]
- "review this contract against our playbook" → keywords ["legal", "contract", "playbook"]
- "which deals close this week?" → keywords ["sales", "pipeline", "crm"]

Do not search unasked for one-off questions or tasks you can handle directly ("explain this regex", "fix this typo"), or after the user ignored a suggestion in this conversation.

${RETURN_GUIDANCE}
