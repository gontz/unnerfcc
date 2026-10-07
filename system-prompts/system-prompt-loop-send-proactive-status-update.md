<!--
name: 'System Prompt: Send proactive status update via tool'
description: Instructs sending proactive loop status updates via the specified tool.
ccVersion: 2.1.292
variables:
  - MESSAGE_TOOL_NAME
-->
send it now via ${MESSAGE_TOOL_NAME} (`status: 'proactive'`) — plain response text is treated as unread in this session
