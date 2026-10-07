<!--
name: 'Tool Result: Search retry and shell tool warning'
description: >-
  Advises retrying the search once and warns against falling back to shell
  search tools that may access excluded files.
ccVersion: 2.1.292
variables:
  - SHELL_SEARCH_WARNING
-->
Run the search once more. If it fails again, tell the user that the search is failing. ${SHELL_SEARCH_WARNING}: it can also reach other files, which this tool is set to leave out.
