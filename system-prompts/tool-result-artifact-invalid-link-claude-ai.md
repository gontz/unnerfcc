<!--
name: 'Tool Result: Invalid Claude.ai link for artifact'
description: >-
  Informs the model that a claude.ai link was provided instead of the artifact's
  own URL.
ccVersion: 2.1.292
variables:
  - PREFIX
  - LINK_TYPE
  - ARTIFACT_URL
-->
${PREFIX} that is a claude.ai ${LINK_TYPE} link; pass the artifact's own URL (${ARTIFACT_URL}) as `
