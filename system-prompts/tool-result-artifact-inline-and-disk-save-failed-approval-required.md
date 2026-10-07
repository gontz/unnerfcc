<!--
name: 'Tool Result: Artifact inline and disk save failed (approval required)'
description: >-
  Informs the model that saving to disk failed and re-reading requires user
  approval.
ccVersion: 2.1.292
variables:
  - READ_ACTION_SYNTAX
-->
Its source could not be shown inline and saving it to disk failed here. Re-read it (${READ_ACTION_SYNTAX}) — that read asks the user to approve reading this artifact and, once they approve, it arrives inline if it fits; if they decline, or it comes back TRUNCATED or marked as not the exact bytes, tell the user, and do not republish from a summary or such a copy.
