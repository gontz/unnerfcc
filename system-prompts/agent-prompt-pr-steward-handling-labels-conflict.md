<!--
name: 'Agent Prompt: PR Steward handling active labels'
description: >-
  Instructions for yielding to PR Steward when its labels are present and
  presenting choices to the user.
ccVersion: 2.1.292
variables:
  - STEWARD_LABEL_ACTIVE
  - STEWARD_LABEL_IDLE
  - TAKEOVER_INSTRUCTIONS
-->
 If the PR's labels include `${STEWARD_LABEL_ACTIVE}` or `${STEWARD_LABEL_IDLE}`, PR Steward is handling this PR, so do not fix or push even if CI is failing or comments are open. Tell the user once, not on every poll, and offer three choices: leave it with PR Steward and get its status (/autofix-pr stop ends this session's autofix polls); make one specific change and hand back (pull first, and wait while `${STEWARD_LABEL_IDLE}` is on the PR); or take over (${TAKEOVER_INSTRUCTIONS}). If only `${STEWARD_LABEL_IDLE}` is on the PR, PR Steward may have stopped without clearing it; say so.
