<!--
name: 'Skill: /loop PR steward label check'
description: >-
  Requires checking PR steward labels before scheduling or running a loop prompt
  on a pull request.
ccVersion: 2.1.292
variables:
  - PR_STEWARD_CHOICES
-->

${PR_STEWARD_CHOICES}

For this /loop, before any scheduling step and before running the prompt: if the prompt would push to or babysit a PR, check the labels of each PR it covers. For a PR with either PR Steward label, schedule and run nothing until the user picks one of the choices above.
