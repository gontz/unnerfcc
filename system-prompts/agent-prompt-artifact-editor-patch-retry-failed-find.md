<!--
name: 'Agent Prompt: Artifact editor patch retry failed find block'
description: >-
  Shows the failed find string and instructs the artifact editor to respond
  again with a decision object.
ccVersion: 2.1.292
variables:
  - FAILED_FIND_STRING
-->
:
<failed_find>
${FAILED_FIND_STRING}
</failed_find>
Respond again with one decision object.
