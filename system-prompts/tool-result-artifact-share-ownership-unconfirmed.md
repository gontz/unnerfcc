<!--
name: 'Tool Result: Artifact ownership unconfirmed'
description: >-
  Informs that artifact ownership could not be verified and provides retry
  instructions.
ccVersion: 2.1.292
variables:
  - URL
  - FOLLOW_UP_GUIDANCE
-->
Couldn't confirm that the person owns the Artifact at ${URL}, so nothing was shared. Retry once; if it still fails, ${FOLLOW_UP_GUIDANCE}
