<!--
name: 'Tool Result: Auto mode wait advice not unsafe'
description: >-
  Notes that classifier backoff is not a safety judgment and not to rework the
  action.
ccVersion: 2.1.292
variables:
  - WAIT_PREFIX
  - ACTION_DESCRIPTION
-->
${WAIT_PREFIX}${ACTION_DESCRIPTION} until then. This is not a judgment that the action is unsafe, so don't rework the action to get around it. 
