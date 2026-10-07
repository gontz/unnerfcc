<!--
name: 'Skill: Code Review findings empty array tool only'
description: >-
  Instructs calling the report tool with an empty array if no findings qualify
  and emitting no plain text.
ccVersion: 2.1.292
-->
 If
nothing survives verification, call it with an empty array. Do not also print
the findings as text, and do not create or publish an artifact of the review -
the tool call is the report.
