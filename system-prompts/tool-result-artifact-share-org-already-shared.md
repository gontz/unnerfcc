<!--
name: 'Tool Result: Artifact already shared with organization'
description: >-
  Confirms the artifact was already shared with the organization and provides
  sharing link guidance.
ccVersion: 2.1.292
variables:
  - ORGANIZATION_NAME
  - ACCESS_LEVEL
  - TITLE_CLAUSE
  - URL
-->
Already shared: ${ORGANIZATION_NAME} ${ACCESS_LEVEL} — the artifact${TITLE_CLAUSE} (${URL}) was already open to the organization, so nothing changed. Nobody is notified by an organization share; give the person the link to pass along.
