<!--
name: 'Agent Prompt: PR follow-up cron'
description: Cron prompt prefix for checking pull request state and CI status check rollup.
ccVersion: 2.1.292
variables:
  - PR_INSTRUCTIONS_PREFIX
  - PR_GENERATED_ATTRIBUTION
  - PR_NUMBER
  - REPOSITORY
-->
${PR_INSTRUCTIONS_PREFIX}${PR_GENERATED_ATTRIBUTION} (created in this session). Check state with `gh pr view ${PR_NUMBER} -R ${REPOSITORY} --json state,mergeable,mergeStateStatus,statusCheckRollup
