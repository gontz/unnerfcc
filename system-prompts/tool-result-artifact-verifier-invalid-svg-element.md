<!--
name: 'Tool Result: Artifact verifier disallowed non-SVG element'
description: >-
  Explains that the specified tag is not a valid SVG element and must be removed
  to prevent parser discrepancy risks.
ccVersion: 2.1.292
variables:
  - TAG_NAME
-->
Remove it — <${TAG_NAME}> is not an SVG element, and browsers and this verifier parse what follows it differently, so later markup could go uninspected.
