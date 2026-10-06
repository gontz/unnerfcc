<!--
name: 'Skill: Code Review low effort one-line text output'
description: >-
  Instructs emitting low-effort review findings as one-line text entries without
  calling tools.
ccVersion: 2.1.292
variables:
  - REPORT_FINDINGS_TOOL_NAME
-->
, most-severe first, one line each:
`path/to/file.ext:123 — what's wrong and the concrete failure`. If nothing
qualifies, output exactly `(none)`. Do not call the
${REPORT_FINDINGS_TOOL_NAME} tool even if it is available.
