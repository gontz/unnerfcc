<!--
name: 'Tool Description: Artifact publishing intent and tool loading'
description: >-
  Explains when to load and use the artifact tool for documents, plans,
  analyses, and visuals intended for other readers.
ccVersion: 2.1.292
variables:
  - TOOL_SEARCH_TOOL
  - ARTIFACT_TOOL_NAME
-->
publishes pages on claude.ai; reads claude.ai artifact links. Load it with ${TOOL_SEARCH_TOOL} (select:${ARTIFACT_TOOL_NAME}) before writing any document, plan, analysis or visual, and whenever other people come up as readers, even after the work is written. Its description says whether to publish, offer a page or do neither.
