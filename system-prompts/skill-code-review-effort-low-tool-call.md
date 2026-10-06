<!--
name: 'Skill: Code Review low effort tool call reporting'
description: Instructs reporting low-effort review findings via a single tool call.
ccVersion: 2.1.292
variables:
  - REPORT_FINDINGS_TOOL_NAME
-->
, most-severe first, in one
${REPORT_FINDINGS_TOOL_NAME} call with `{level, findings}` — each entry has
`file`, `line`, `summary`, `short_summary` (≤60 characters), and
`failure_scenario`. If nothing qualifies, call it with an empty findings
array. Do not also print the findings as text.
