<!--
name: 'Tool Result: Workflow hidden script not loaded'
description: >-
  Error when resuming a workflow run whose script is hidden and not loaded in
  the session.
ccVersion: 2.1.292
-->
This workflow run hides its script, and this session has not loaded that script yet. If its background resume is still running, wait for it; if that resume failed, start a new run without resumeFromRunId.
