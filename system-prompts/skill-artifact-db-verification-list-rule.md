<!--
name: 'Skill: Artifact db verification list rule'
description: >-
  Instructs verifying collections written by the page with list calls and access
  level checks.
ccVersion: 2.1.280
variables:
  - TOOL_NAME
-->
after the first publish, one `${TOOL_NAME}` `list` of each collection the page writes, and, where its rules hide something from ordinary viewers, the same read with a lower `as_level`, which must not show what the rules hide from such a viewer
