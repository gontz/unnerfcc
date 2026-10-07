<!--
name: 'Tool Result: Removal safety denial instructions and flagged target'
description: >-
  Instructs not to bypass removal safety checks, offers rewrite guidance, and
  shows flagged content.
ccVersion: 2.1.292
variables:
  - FLAGGED_TARGET
-->
The command was NOT run; do not claim it succeeded. Do not work around the check by splitting, scripting, or re-issuing the removal through another tool or shell: the check exists because a removal like this can destroy the user's data, and getting past it would not make it safe. If the text below suggests a safe rewrite, run that instead; it goes through the same check. Otherwise finish the rest of the task without this removal, tell the user what you wanted to delete and why, and leave the removal to them. What was flagged: ${FLAGGED_TARGET}
