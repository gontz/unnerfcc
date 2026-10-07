<!--
name: 'Tool Result: WebFetch read on paging instruction'
description: Instructs how to read subsequent pages using WebFetch with url and offset.
ccVersion: 2.1.292
variables:
  - TOOL_NAME
  - NEXT_OFFSET
-->
 — to read on, call ${TOOL_NAME} again with the same url and offset: ${NEXT_OFFSET}
