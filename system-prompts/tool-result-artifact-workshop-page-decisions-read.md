<!--
name: 'Tool Result: Workshop page decisions read guidance'
description: >-
  Instructs reading live decisions of a workshop page using read_page_data
  instead of raw source.
ccVersion: 2.1.292
variables:
  - ARTIFACT_TOOL_NAME
  - FOLLOWUP_ACTION
-->
It is a workshop page, so its source is not handed over: read its live decisions with the ${ARTIFACT_TOOL_NAME} tool's read_page_data action (schema "workshop-decisions") — that normally counts as viewing this version — then ${FOLLOWUP_ACTION} — do not resend your previous content unchanged. The workshop skill forbids a content read and force here.
