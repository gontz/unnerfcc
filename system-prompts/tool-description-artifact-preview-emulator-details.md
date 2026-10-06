<!--
name: 'Tool Description: Artifact preview emulator details'
description: >-
  Describes the artifact preview emulator environment, local headless browser
  behavior, and network policy restrictions.
ccVersion: 2.1.292
variables:
  - FILE_PATH
-->
preview local file ${FILE_PATH} in the artifact emulator (on first use downloads the artifact viewer from the artifact service, then runs it with a headless browser in this session on a private copy of the file; nothing is published; the page can reach only port 443 of the artifact page policy's hosts, where the organization's network settings allow)
