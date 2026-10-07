<!--
name: 'Tool Result: Unprompted artifact publish restricted'
description: >-
  Explains that unprompted artifact publishing cannot modify capabilities or
  files without permission.
ccVersion: 2.1.292
variables:
  - VIOLATION_REASON
-->
Nothing was published: a publish made without asking may only create a new artifact, naming no url and setting no capabilities, contract, force, file removals or live files, but this one ${VIOLATION_REASON}. Every publish in this session now goes through the usual permission check, which may need a person's approval.
