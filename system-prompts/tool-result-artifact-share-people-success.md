<!--
name: 'Tool Result: Artifact shared with people'
description: Confirms the artifact has been shared with specified organization members.
ccVersion: 2.1.292
variables:
  - TITLE_CLAUSE
  - URL
  - CONFIRMED_PEOPLE_COUNT_OR_LABEL
  - ACCESS_LEVEL_DESCRIPTION
  - EMAIL_NOTIFICATION_NOTE
  - EXTRA_NOTE
-->
Shared the artifact${TITLE_CLAUSE} (${URL}) with ${CONFIRMED_PEOPLE_COUNT_OR_LABEL}: they ${ACCESS_LEVEL_DESCRIPTION}${EMAIL_NOTIFICATION_NOTE}, and each gets claude.ai's usual invite email.${EXTRA_NOTE} The card, not your `people` hints, decided who they are — do not name individuals as shared-with unless the person confirms who they picked. They can change or undo this from the Share menu on the artifact's page.
