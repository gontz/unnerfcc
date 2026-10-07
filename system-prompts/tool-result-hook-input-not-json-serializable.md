<!--
name: 'Tool Result: Hook input not JSON serializable'
description: >-
  Informs the model that a tool call was blocked because its input could not be
  serialized to JSON for hook evaluation.
ccVersion: 2.1.292
-->
Blocked: this call's input can't be written as JSON, so the hook could not check it. The input is too large, or contains a value that JSON can't represent (such as a BigInt or a circular reference). Retry with a smaller, plain input.
