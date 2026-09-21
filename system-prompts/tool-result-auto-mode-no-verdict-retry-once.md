<!--
name: 'Tool Result: Auto mode no verdict retry once'
description: >-
  Informs the model that auto mode gave no verdict, instructing it to retry the
  action once as-is.
ccVersion: 2.1.278
variables:
  - REASON_SUFFIX
-->
. Issue the action again once, as-is; if it is denied again, continue with other tasks that don't require it and tell the user that auto mode could not evaluate it. ${REASON_SUFFIX}
