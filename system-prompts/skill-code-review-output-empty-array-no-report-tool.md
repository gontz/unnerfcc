<!--
name: 'Skill: Code Review output empty array without report tool'
description: >-
  Instructs returning an empty JSON array if no findings survive and forbids
  calling the report tool.
ccVersion: 2.1.292
variables:
  - REPORT_FINDINGS_TOOL_NAME
-->
 If nothing survives verification, return `[]`. Do not call the
${REPORT_FINDINGS_TOOL_NAME} tool even if it is available - this review's
output contract is the JSON block above.
