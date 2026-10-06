<!--
name: 'Tool Result: Unowned artifact read unattended denial'
description: >-
  Informs the model that reading an unowned artifact requires human approval
  that cannot be answered unattended.
ccVersion: 2.1.292
variables:
  - ARTIFACT_DETAILS
-->
${ARTIFACT_DETAILS}. Reading content of an artifact the user does not own, or whose ownership couldn't be confirmed, needs a person's yes, and no one can answer the prompt in this session — tell the user in chat instead of retrying.
