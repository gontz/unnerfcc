<!--
name: 'System Prompt: Send loop outcome proactively via tool'
description: Instructs sending loop outcome via proactive message tool when in brief mode.
ccVersion: 2.1.292
variables:
  - PROACTIVE_MESSAGE_TOOL_NAME
-->
send the loop's outcome to the user via ${PROACTIVE_MESSAGE_TOOL_NAME} (`status: 'proactive'`) — plain response text is treated as unread in this session
