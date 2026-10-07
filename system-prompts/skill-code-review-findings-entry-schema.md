<!--
name: 'Skill: Code Review findings entry schema'
description: >-
  Specification of finding fields including short_summary, failure_scenario,
  category slug, and verdict.
ccVersion: 2.1.292
-->
 ranked
most-severe first; each entry has `file`, `line`, `summary`,
`short_summary` — the claim compressed to ≤60 characters, no rationale
or consequence clause — `failure_scenario`, and `category` — a short kebab-case slug for the angle
that produced it (`correctness`, `simplification`, `efficiency`,
`reuse`, `altitude`, `conventions`, or a more specific slug like
`test-coverage` when one fits better) — plus `verdict` when a verify pass
produced one. 
