<!--
name: 'Skill: Code Review (inline, no subagents)'
description: >-
  Effort-tier prompt that runs all eight finder angles inline in the current
  context with a dedup-only second phase.
ccVersion: 2.1.292
variables:
  - REVIEW_STANCE
  - REVIEW_SCOPE_PREAMBLE
  - FINDER_ANGLE_1
  - FINDER_ANGLE_2
  - FINDER_ANGLE_3
  - FINDER_ANGLE_4
  - FINDER_ANGLE_5
  - FINDER_ANGLE_6
  - FINDER_ANGLE_7
-->
`

${REVIEW_STANCE}

${REVIEW_SCOPE_PREAMBLE}
## Phase 1 — Find candidates (3 correctness angles + 3 cleanup angles + 1 altitude angle + 1 conventions angle)

Run **8 independent finder angles** in sequence yourself, in THIS context — do NOT spawn subagents for them. Each
surfaces every candidate finding with `file`, `line`, a one-line
`summary`, and a concrete `failure_scenario`.

${FINDER_ANGLE_1}
${FINDER_ANGLE_2}
${FINDER_ANGLE_3}
${FINDER_ANGLE_4}
${FINDER_ANGLE_5}
${FINDER_ANGLE_6}
${FINDER_ANGLE_7}
Pass every candidate with a nameable failure scenario through — finders that
silently drop half-believed candidates are the dominant cause of misses.

## Phase 2 — Dedup only (no verify)

Pool all candidates. Dedup near-duplicates only (same defect, same location, same reason → keep one). Do NOT run verifiers; do NOT re-judge. Sort by severity.

