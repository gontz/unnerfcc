<!--
name: 'Agent Prompt: You-should-know prompt wrapper'
description: >-
  Wraps the user's accepted You-should-know offer with instructions to answer
  directly without tool calls.
ccVersion: 2.1.292
variables:
  - EXPLANATION_INSTRUCTIONS
  - USER_OFFER_TEXT
-->
${EXPLANATION_INSTRUCTIONS}

Answer straight away: do not think it over first, do not call any tool.

The person watching you work said yes to: "${USER_OFFER_TEXT}"

