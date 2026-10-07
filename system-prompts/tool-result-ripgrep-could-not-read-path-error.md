<!--
name: 'Tool Result: Ripgrep could not read path error'
description: >-
  Reports that ripgrep failed to read the search path due to an OS error rather
  than finding no matches.
ccVersion: 2.1.292
variables:
  - SEARCH_PATH
  - OS_ERROR_CODE
  - RECOVERY_INSTRUCTION
-->
Search failed: ripgrep could not read the path it was given (${SEARCH_PATH}, os error ${OS_ERROR_CODE}), so nothing was searched. This is not a "no matches" result. ${RECOVERY_INSTRUCTION}
