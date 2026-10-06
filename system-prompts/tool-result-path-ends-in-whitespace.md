<!--
name: 'Tool Result: Path ends in whitespace'
description: Informs the model that the tool refuses paths ending in whitespace.
ccVersion: 2.1.292
variables:
  - TOOL_NAME
-->
 ends in white space once its "." and ".." are resolved, and ${TOOL_NAME} refuses such a path. If the white space is not meant, send the path without it. ${TOOL_NAME} cannot open a file whose own name ends in white space.
