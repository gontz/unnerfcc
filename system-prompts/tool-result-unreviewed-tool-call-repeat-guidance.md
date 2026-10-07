<!--
name: 'Tool Result: Unreviewed tool call repeat once guidance'
description: Instructs repeating an unreviewed tool call once for auto mode evaluation.
ccVersion: 2.1.292
variables:
  - TOOL_CALL_NAME
  - CLASSIFIER_NAME
-->
${TOOL_CALL_NAME} did not run. ${CLASSIFIER_NAME} gave no verdict because it was not shown this call; that is not a judgment that the call is unsafe. Repeat the identical ${TOOL_CALL_NAME} call once now; the repeat will be reviewed as usual. If the repeat does not run either, continue with other tasks that don't require it and tell the user that auto mode could not evaluate it. 
