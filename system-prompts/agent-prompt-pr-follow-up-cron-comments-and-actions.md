<!--
name: 'Agent Prompt: PR follow-up cron comments and actions'
description: >-
  Cron prompt instructions for fetching review comments, fixing CI/merge issues,
  and deleting cron on merge/close.
ccVersion: 2.1.292
variables:
  - REPOSITORY
  - PR_NUMBER
  - CRON_DELETE_TOOL
  - REPORT_OUTCOME_NOTE
  - FIX_AND_PUSH_NOTE
-->
` and new review comments with `gh api --paginate repos/${REPOSITORY}/pulls/${PR_NUMBER}/comments`. If MERGED or CLOSED, delete this cron with ${CRON_DELETE_TOOL} and report the outcome.${REPORT_OUTCOME_NOTE} If CI is failing, comments are unaddressed, or there are merge conflicts, fix and push.${FIX_AND_PUSH_NOTE} Otherwise nothing to do — complete the turn without commentary.
