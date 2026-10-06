<!--
name: 'Tool Result: Auto mode turn wait instructions and stop'
description: >-
  Explains that the model cannot wait out classifier backoff within the turn and
  should report the wait time.
ccVersion: 2.1.292
variables:
  - WAIT_DURATION
-->
You cannot wait this out inside the turn. Do not retry the action before then, and do not try any other action that needs auto mode's review: while the API still says to wait, each one is denied the same way, without being reviewed. Continue with work that needs no review. If there is none, stop and tell the user that auto mode has to wait ${WAIT_DURATION} for the API and that they can try again after that. When the user next asks, you may try again. 
