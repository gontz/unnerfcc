<!--
name: 'Tool Result: Artifact multi-publish files limit advice'
description: >-
  Advises splitting artifact publishing across multiple publish calls to the
  same URL.
ccVersion: 2.1.292
variables:
  - MAX_TOTAL_FILES
-->
 files now and add the rest with another publish to the same url — files left out of a later publish are kept, and a version holds up to ${MAX_TOTAL_FILES} in all.
