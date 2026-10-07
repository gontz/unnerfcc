<!--
name: 'Skill: Code Review (medium effort)'
description: >-
  Effort-tier prompt for medium code review — 8 finder angles, uncapped candidate
  reporting, precision-biased, all qualifying findings
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

You are reviewing for **precision** at medium effort: every finding you surface
should be one a maintainer would act on.

${REVIEW_SCOPE_PREAMBLE}
## Phase 1 — Find candidates (3 correctness angles + 3 cleanup angles + 1 altitude angle + 1 conventions angle)

Run **8 independent finder angles** via the ${AGENT_TOOL_NAME} tool. Each
surfaces all candidate findings with `file`, `line`, a
`summary`, and a concrete `failure_scenario`. ${FINDER_INSTRUCTIONS}

${PHASE_2_VERIFY}
${PHASE_3_SYNTHESIZE}
Pass every candidate with a nameable failure scenario through — finders that
silently drop half-believed candidates bypass the verify step and are the
dominant cause of misses.

${OUTPUT_SECTION}
