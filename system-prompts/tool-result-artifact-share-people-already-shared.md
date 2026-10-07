<!--
name: 'Tool Result: Artifact already shared with specified people'
description: >-
  Confirms specified people already had access to the artifact so no changes
  occurred.
ccVersion: 2.1.292
variables:
  - PEOPLE_COUNT_OR_LABEL
  - TITLE_CLAUSE
  - URL
  - EXTRA_NOTE
-->
Already shared: the ${PEOPLE_COUNT_OR_LABEL} could already open the artifact${TITLE_CLAUSE} (${URL}) with that access, so nothing changed and no one was emailed.${EXTRA_NOTE} Give the person the link to pass along.
