<!--
name: 'Tool Result: Invalid pages parameter in Read tool'
description: >-
  Error result explaining invalid pages syntax and specifying accepted page and
  range formats.
ccVersion: 2.1.292
variables:
  - INVALID_PAGES_PARAMETER
-->
Invalid pages parameter: "${INVALID_PAGES_PARAMETER}". Give one page ("3") or one range ("1-5"), not a list. To read several pages or ranges, read each one separately. Pages are 1-indexed.
