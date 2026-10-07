<!--
name: 'Skill: Code Review output cap condition'
description: >-
  Instructs keeping only the most severe findings if the count exceeds the
  maximum.
ccVersion: 2.1.292
variables:
  - MAX_FINDINGS
-->
Report every finding that survives, most severe first; ${MAX_FINDINGS} is a
floor, not a ceiling, and never a reason to drop a real ${MAX_FINDINGS}th finding.
