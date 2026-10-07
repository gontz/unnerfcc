<!--
name: 'Tool Result: Skill proposals shown to the user'
description: >-
  Confirms the skill proposals were shown for review and tells the model to
  continue with the next phase rather than wait for a response.
ccVersion: 2.1.292
variables:
  - PROPOSAL_COUNT
  - CARD_POSITION_NOTE
-->
Shown ${PROPOSAL_COUNT} skill proposal(s) to the user for review.${CARD_POSITION_NOTE} Continue with the next phase; do not wait for them to respond.
