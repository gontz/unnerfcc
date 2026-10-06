<!--
name: 'Agent Prompt: Example Encryption Jargon Overload'
description: >-
  Bad example of a "learn:" line overloaded with dense cryptographic and
  architectural jargon.
ccVersion: 2.1.292
-->
learn: Your Orders DB at-rest encryption uses envelope encryption with per-table data keys wrapped by a KMS master key, so every cold read pays a KMS decrypt round-trip plus AES-GCM overhead on the hot path
