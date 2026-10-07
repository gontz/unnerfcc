<!--
name: 'Agent Prompt: Example YAML Quirk Trivia'
description: >-
  Example "learn:" line explaining how YAML parses "no" as false without project
  impact.
ccVersion: 2.1.292
-->
learn: The YAML parser in this repo reads the word "no" as false, which trips up a lot of configs 
