<!--
name: 'Skill: Code Review (high effort)'
description: >-
  Effort-tier prompt for high code review — 8 finder angles, uncapped candidate
  reporting, recall-biased, all qualifying findings
ccVersion: 2.1.292
variables:
  - REVIEW_SCOPE_PREAMBLE
  - AGENT_TOOL_NAME
  - FINDER_INSTRUCTIONS
  - PHASE_2_VERIFY
  - PHASE_3_SYNTHESIZE
  - OUTPUT_SECTION
-->
`

You are reviewing for **recall** at high effort: catch every real bug a careful
reviewer would catch in one sitting. At this level, catching real bugs matters
more than avoiding false positives. Err on the side of surfacing.

${REVIEW_SCOPE_PREAMBLE}
## Phase 1 — Find candidates (3 correctness angles + 3 cleanup angles + 1 altitude angle + 1 conventions angle, uncapped)

Run **8 independent finder angles** via the ${AGENT_TOOL_NAME} tool. Each
surfaces all candidate findings with `file`, `line`, a one-line
`summary`, and a concrete `failure_scenario`. ${FINDER_INSTRUCTIONS}

${PHASE_2_VERIFY}
${PHASE_3_SYNTHESIZE}
Pass every candidate with a nameable failure scenario through — finders that
silently drop half-believed candidates bypass the verify step and are the
dominant cause of misses.

${OUTPUT_SECTION}
