<!--
name: 'Tool Result: Page or XML copy disallowed in publish'
description: >-
  Explains that page and XML documents must be read locally and published rather
  than server-copied.
ccVersion: 2.1.292
variables:
  - FOLLOW_UP_NOTE
-->
: a page or XML document cannot be copied from another artifact into a publish (its content must pass this tool's checks, which a server-side copy skips) — read it with action "read_file" and publish it from the local copy instead. Nothing was published.${FOLLOW_UP_NOTE}
