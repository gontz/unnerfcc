<!--
name: 'Tool Result: Remote command output withheld after post-hook failure'
description: >-
  Explains that command output is withheld because a PostToolUse hook failed or
  was stopped before completion.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
  - REASON
-->
(output withheld: the command COMPLETED on ${MACHINE_NAME} and was not interrupted. What ran after it here — a PostToolUse hook, most likely — was stopped ${REASON} before it finished, and it may have been meant to check this output, so only the output is withheld. Do not re-run the command just to see the output unless it is safe to repeat.)
