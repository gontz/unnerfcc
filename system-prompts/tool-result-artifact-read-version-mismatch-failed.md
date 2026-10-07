<!--
name: 'Tool Result: Artifact read version mismatch failed'
description: >-
  Explains that the artifact read failed because the server returned a different
  version than requested.
ccVersion: 2.1.292
-->
artifact read failed: the server served a different version from the one asked for, so nothing was read. It does that for an account that cannot edit the artifact; for one that can, the server ignored the version asked for.
