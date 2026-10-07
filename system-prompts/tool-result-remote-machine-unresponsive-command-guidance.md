<!--
name: 'Tool Result: Remote machine unresponsive command state unknown guidance'
description: >-
  Advises against re-running non-idempotent commands when a remote machine's
  response was lost, suggesting narrower commands or proceeding without it.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
-->
 s apart got no answer, though ${MACHINE_NAME} answered a liveness check). Its state is unknown — it may have completed, failed, or still be running; the reply may have been too large to deliver. Do not re-run non-idempotent commands on ${MACHINE_NAME} just to see the output. If the output may be large, try a narrower command (part of a file, a filter, or a smaller image); otherwise do the rest of the task without ${MACHINE_NAME}, and tell the user what you could not verify.
