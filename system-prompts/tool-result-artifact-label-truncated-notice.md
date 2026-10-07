<!--
name: 'Tool Result: Artifact publish label truncated notice'
description: >-
  Notes that the artifact version label exceeded the character limit and was
  truncated to length.
ccVersion: 2.1.292
variables:
  - MAX_CHARS
-->
Note: `label` was longer than ${MAX_CHARS} characters and was cut to that length; only its start was kept. A label is a few words naming the version, not a description of the changes.
