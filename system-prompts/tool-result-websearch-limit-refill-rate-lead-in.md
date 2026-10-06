<!--
name: 'Tool Result: WebSearch limit refill rate lead-in'
description: Describes web search budget limit and hourly refill rate.
ccVersion: 2.1.292
variables:
  - SEARCH_LIMIT
  - SCOPE_UNIT
  - REFILL_RATE
-->
limit: ${SEARCH_LIMIT} shared by every agent in this ${SCOPE_UNIT}; the budget refills at about ${REFILL_RATE} 
