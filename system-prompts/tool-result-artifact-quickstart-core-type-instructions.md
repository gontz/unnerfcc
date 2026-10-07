<!--
name: 'Tool Result: Quickstart core type instructions'
description: >-
  Instructs publishing with the core type's type_url or routing the document to
  the attached connector.
ccVersion: 2.1.292
variables:
  - PUBLISH_PARAMS
  - CONNECTOR_NOTE
  - FORMAT_SKILL_NOTE
  - NEXT_STEP
-->
` (a row opens with the type's first-party tier in brackets, when it has one, then its title in quotes), start from that type: publish with its `type_url`, ${PUBLISH_PARAMS}; if none does, the document goes to the connector, and to its skill when one appears in your skill list. ${CONNECTOR_NOTE}${FORMAT_SKILL_NOTE} ${NEXT_STEP}
