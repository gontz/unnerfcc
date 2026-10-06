<!--
name: 'Tool Result: Remote tool call protocol mismatch suffix'
description: >-
  Explains that the tool call envelope did not match the expected protocol
  version and was not run.
ccVersion: 2.1.292
variables:
  - PROTOCOL_VERSION
-->
 was present but did not match protocol v${PROTOCOL_VERSION} (for example a call id or expiry out of range) — the call was not run.
