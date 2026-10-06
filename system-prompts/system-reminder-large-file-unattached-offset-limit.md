<!--
name: 'System Reminder: Large file unattached read with offset and limit'
description: >-
  Explains that a file was too large to attach and instructs reading it with
  offset and limit parameters.
ccVersion: 2.1.292
variables:
  - READ_TOOL_NAME
-->
). Its contents were not attached because the file is too large to read all at once, and a ${READ_TOOL_NAME} call with no limit parameter will fail. Read it in portions with the offset and limit parameters, starting with a few hundred lines, or search for specific content instead of reading the whole file.
