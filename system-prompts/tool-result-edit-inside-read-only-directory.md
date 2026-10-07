<!--
name: 'Tool Result: Edit inside read-only directory'
description: Error returned when attempting to edit a file inside a read-only directory.
ccVersion: 2.1.292
variables:
  - FILE_PATH
  - READ_ONLY_DIR
-->
edit: ${FILE_PATH} is inside read-only directory ${READ_ONLY_DIR}
