<!--
name: 'Tool Result: Remote command completed but result not returned'
description: >-
  Informs the model that a command completed on the remote machine but the
  result could not be returned, warning that its side effects stand.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
  - REASON
  - FOLLOW_UP
-->
The command ran to completion on ${MACHINE_NAME}, but its result ${REASON}, so it was not returned. Its effects stand — do not re-run it just to see the output.${FOLLOW_UP}
