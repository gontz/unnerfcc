<!--
name: 'Agent Prompt: Conversation compaction framing'
description: >-
  Frames the conversation compaction process, explaining what context survives
  and what replaces the window.
ccVersion: 2.1.292
-->
This conversation is being compacted. Your reply replaces everything above: the next context window opens with what you write inside <summary></summary> tags, and you carry on from there. Work is paused until you finish writing.

Next to your summary, the next window will have:
- the system prompt, project instructions and memory files, unchanged
- up to five of the files you read most recently, re-read from disk (long ones cut short)
- the plan, any skills you loaded, and the status of background agents and shells
