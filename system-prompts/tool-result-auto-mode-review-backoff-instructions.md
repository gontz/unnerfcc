<!--
name: 'Tool Result: Auto mode review backoff instructions'
description: >-
  Instructs not to retry actions needing auto mode review while the backoff
  period lasts.
ccVersion: 2.1.292
-->
Do not retry the action before then, and do not try any other action that needs auto mode's review: while the API still says to wait, each one is denied the same way, without being reviewed. 
