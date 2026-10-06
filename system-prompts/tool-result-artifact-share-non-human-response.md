<!--
name: 'Tool Result: Artifact share answered by hook or rule'
description: >-
  Informs that only human user approval is valid for artifact sharing and a hook
  or rule answered.
ccVersion: 2.1.292
variables:
  - FOLLOW_UP_GUIDANCE
-->
Only the person can approve a share, and this one was answered by something else (a hook or rule), so nothing was shared; do not retry it here. ${FOLLOW_UP_GUIDANCE}
