<!--
name: 'Data: Artifact publish file freshness rule'
description: >-
  Instructs on reading files before editing unless already visible and
  unmodified in context.
ccVersion: 2.1.292
variables:
  - READ_TOOL_CALL
-->
a file you wrote or read in this conversation and still see above is current until a publish is refused: edit it, no read first; read any other file you will change (${READ_TOOL_CALL}) before editing it.
