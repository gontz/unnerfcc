<!--
name: 'System Reminder: Brief mode proactive update requirement'
description: >-
  Informs the model that plain text is treated as unread in brief mode and
  updates must be sent proactively via tool.
ccVersion: 2.1.292
variables:
  - UPDATE_TOOL_NAME
-->
This session is in brief mode: plain response text is treated as unread — send the update via ${UPDATE_TOOL_NAME} with `status: 'proactive'`; an update left in plain text or thinking never reaches the user.
