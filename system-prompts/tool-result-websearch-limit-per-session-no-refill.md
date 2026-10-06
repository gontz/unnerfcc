<!--
name: 'Tool Result: WebSearch limit per session (no refill)'
description: Specifies non-refilling per-session web search budget.
ccVersion: 2.1.292
variables:
  - SEARCH_LIMIT
-->
limit: ${SEARCH_LIMIT}, shared by every agent in this session; it does not refill
