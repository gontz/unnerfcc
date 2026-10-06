<!--
name: 'Skill: Code Review findings keep most severe'
description: Instructs keeping the top findings by severity if exceeding the maximum.
ccVersion: 2.1.292
variables:
  - MAX_FINDINGS
-->
Report every finding that survives, most severe first; ${MAX_FINDINGS} is a floor, not a ceiling, and never a reason to drop a real ${MAX_FINDINGS}th finding.
