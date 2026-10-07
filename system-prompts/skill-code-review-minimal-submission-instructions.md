<!--
name: 'Skill: Code Review (minimal submission instructions)'
description: >-
  Instructions for submitting findings via the reporting tool and restating them
  in the final reply.
ccVersion: 2.1.292
variables:
  - REPORT_FINDINGS_TOOL_NAME
-->
 via the ${REPORT_FINDINGS_TOOL_NAME} tool, filling its fields as defined — for each: the file path and start line, a severity, and a comment that states the issue and the concrete scenario in which the code misbehaves. Quality over quantity: include everything you genuinely believe is a real issue, and nothing you don't.

After the tool call, also restate the findings in your final reply — one line each, `file:line — summary` — so they stay visible in sessions that do not render tool output.
