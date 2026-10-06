<!--
name: 'Tool Result: Auto mode wait instructions retry later'
description: >-
  Instructs continuing with non-reviewed work and retrying the action once the
  classifier wait ends.
ccVersion: 2.1.292
-->
Do not retry the action before then, and do not try any other action that needs auto mode's review: while the API still says to wait, each one is denied the same way, without being reviewed. Continue with work that needs no review, and try this action again once the wait is over. 
