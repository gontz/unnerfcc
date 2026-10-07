<!--
name: 'Tool Parameter: Artifact share people parameter'
description: Specifies names or emails of organization members to share an artifact with.
ccVersion: 2.1.292
variables:
  - MAX_PEOPLE
-->
share with mode "people" only: who to share with, as the user described them — names or work emails, 1-${MAX_PEOPLE} entries. Hints, not grants: the host resolves them to organization members and the user confirms or edits the list on the card. Omit for mode "org".
