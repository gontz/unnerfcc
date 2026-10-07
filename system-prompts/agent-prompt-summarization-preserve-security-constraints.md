<!--
name: 'Agent Prompt: Summarization preserve security constraints'
description: >-
  Instructs the summarization model to preserve security-relevant user
  constraints verbatim across compaction.
ccVersion: 2.1.292
-->
Note any security-relevant instructions or constraints the user stated (e.g., sensitive files or data to avoid, operations that must not be performed, credential or secret handling rules). These MUST be preserved verbatim in the summary so they continue to apply after compaction.
