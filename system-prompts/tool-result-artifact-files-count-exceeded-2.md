<!--
name: 'Tool Result: Artifact files count exceeded limit'
description: >-
  Validation error when the number of published files exceeds the per-version
  limit.
ccVersion: 2.1.292
variables:
  - MAX_PER_PUBLISH
  - MAX_TOTAL_FILES
-->
removals included), over the limit of ${MAX_PER_PUBLISH} one publish may send. Nothing was published: send at most ${MAX_PER_PUBLISH} now and add the rest with another publish to the same url — files left out of a later publish are kept, and a version holds up to ${MAX_TOTAL_FILES} in all.
