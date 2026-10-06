<!--
name: 'Tool Result: Untrusted repositories blocked calls'
description: >-
  Error stating calls to the machine are blocked because attached repositories
  were not marked trusted.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
-->
This session's attached repositories were not marked trusted, so its calls to ${MACHINE_NAME} are not accepted — nothing was done for this one. Sending it again will not change that: ask the person to answer the trust question, and tell them what stays blocked until they do.
