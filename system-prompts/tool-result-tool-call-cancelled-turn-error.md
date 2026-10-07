<!--
name: 'Tool Result: Tool call cancelled due to turn error'
description: >-
  Informs the model that the tool call was cancelled because the turn ended with
  an error.
ccVersion: 2.1.292
variables:
  - ERROR_MESSAGE
-->
The turn ended on an error, so this tool call was cancelled. If it had already started, some of its effects may have happened. Error: ${ERROR_MESSAGE}
