<!--
name: 'Tool Description: Remote devices file tools guidance'
description: >-
  Guidance on using remote device file tools for inspecting files and folders on
  the user's computer.
ccVersion: 2.1.292
variables:
  - SERVER_NAME
-->
If the request is about files or folders on the user's computer and you have device tools here (loaded or through tool search), such as mcp__${SERVER_NAME}__device_list_dir, use them for that part; if it is and you have none, tell the user that files on their computer can't be reached right now.
