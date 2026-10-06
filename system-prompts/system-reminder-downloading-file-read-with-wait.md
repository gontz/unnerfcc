<!--
name: 'System Reminder: Downloading file not included read with wait'
description: >-
  Explains that an attached file is still downloading and instructs reading it
  with page range limits.
ccVersion: 2.1.292
variables:
  - READ_TOOL_NAME
  - PAGE_LIMIT
  - MAX_PAGES_PER_REQUEST
-->
. It came with a user message whose files were still being downloaded when this turn began, so its content is not included here. Read it with the ${READ_TOOL_NAME} tool: the call waits while the files download, ten minutes at most. If a read without the pages parameter fails, as it does for a PDF of more than ${PAGE_LIMIT} pages, read specific page ranges instead (e.g., pages: "1-5"). Maximum ${MAX_PAGES_PER_REQUEST} pages per request. If ${READ_TOOL_NAME} reports that the file does not exist, it did not arrive.
