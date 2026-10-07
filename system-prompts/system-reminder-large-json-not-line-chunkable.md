<!--
name: 'System Reminder: Large JSON is not line-chunkable'
description: >-
  Tells the model to probe the file's structure with jq and extract slices with
  jq or python because Read's line-based offset/limit cannot chunk it.
ccVersion: 2.1.292
variables:
  - EXTRACTION_COMMAND
  - READ_TOOL_NAME
-->
${EXTRACTION_COMMAND} — ${READ_TOOL_NAME}'s line-based offset/limit will not chunk this file.
