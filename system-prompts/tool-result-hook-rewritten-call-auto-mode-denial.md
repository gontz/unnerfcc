<!--
name: 'Tool Result: Hook rewritten call unevaluated by auto mode'
description: >-
  Explains that auto mode could not evaluate a call rewritten by a hook and
  gives retry and user notification instructions.
ccVersion: 2.1.292
variables:
  - CLASSIFIER_NAME
  - TOOL_CALL_NAME
-->
${CLASSIFIER_NAME} gave no verdict for ${TOOL_CALL_NAME}: a hook changed this call's input after the model wrote it, so the review was of different input from what would run, and no other review of it was available. This is not a judgment that the action is unsafe. Issue the call again once, as this conversation records it; if it is denied again, the hook changes it each time, so do not issue it again: continue with other tasks that don't require it, and tell the user that a hook (a PreToolUse hook, or a mod's) rewrites the ${TOOL_CALL_NAME} call, that auto mode could not evaluate the rewritten call, and that they can turn that hook or mod off (or ask their administrator, if their organization set it), or switch out of auto mode and approve the call themselves. 
