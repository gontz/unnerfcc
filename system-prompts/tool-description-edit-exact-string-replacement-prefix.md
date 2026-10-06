<!--
name: 'Tool Description: Edit exact string replacement prefix'
description: >-
  Opening description of Edit tool stating prior read requirement and uniqueness
  constraint.
ccVersion: 2.1.292
variables:
  - READ_ACTION
-->
Performs exact string replacement in a file.

- You must ${READ_ACTION} the file in this conversation before editing, or the call will fail.
- `old_string` must match the file exactly, including indentation, and be unique — the edit fails otherwise. Strip the Read line prefix (
