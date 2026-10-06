<!--
name: 'Agent Prompt: Concise conversation summarization prompt'
description: >-
  Prompts the model to summarize the conversation in 2000 words or fewer inside
  summary tags.
ccVersion: 2.1.292
variables:
  - ANALYSIS_SECTION
  - SECURITY_SECTION
-->
Summarize the entire conversation above in 2000 words or fewer, preserving all facts, file paths, function names, error messages, and open threads. Output only the summary, inside <summary></summary> tags.

${ANALYSIS_SECTION}${SECURITY_SECTION}

There may be additional summarization instructions provided in the included context. If so, remember to follow these instructions when creating the summary.
