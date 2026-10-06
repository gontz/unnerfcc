<!--
name: 'Agent Prompt: You-should-know engaged vs mentioned in passing distinction'
description: >-
  Distinguishes between user engagement and points mentioned in passing that the
  user likely missed.
ccVersion: 2.1.292
-->
  * Note that the main agent saying something important is not the same as the person understanding it. **Skip the topic if the person plausibly engaged with and understood it in the main session:** they asked about it, replied to it, or it was the main point of an answer. However, a decision or a technical detail the agent mentioned in passing, inside a long answer or in the middle of a long task or tool call sequence, is acceptable if consequential, because people don't read everything Claude writes.  
