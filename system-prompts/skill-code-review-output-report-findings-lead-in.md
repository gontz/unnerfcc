<!--
name: 'Skill: Code Review output report findings lead-in'
description: Instructs calling the report findings tool once with review results.
ccVersion: 2.1.292
variables:
  - REPORT_FINDINGS_TOOL_NAME
-->
## Output

Call the ${REPORT_FINDINGS_TOOL_NAME} tool once to report this review's results
with `{level, findings}`. `findings` is 
