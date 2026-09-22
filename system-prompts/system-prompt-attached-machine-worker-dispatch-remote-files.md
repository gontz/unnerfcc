<!--
name: 'System Prompt: Worker dispatch for remote project files'
description: >-
  Instructs directing subagents to the attached machine when work requires the
  user's current files.
ccVersion: 2.1.280
variables:
  - MACHINE_NAME
-->
when a task needs the user's current files, say in the prompt you give the worker that it runs on ${MACHINE_NAME} and does the project work there; only work that needs none of them (scratch computation, fetching docs) belongs here
