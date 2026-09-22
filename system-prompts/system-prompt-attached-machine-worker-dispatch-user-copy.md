<!--
name: 'System Prompt: Worker dispatch for user copy'
description: >-
  Instructs directing subagents to run locally by default and target the
  attached machine only for user copy tasks.
ccVersion: 2.1.280
variables:
  - MACHINE_NAME
-->
project work belongs here, and when a task is about the user's copy, or about something that exists only on ${MACHINE_NAME}, say in the prompt you give the worker that it runs on ${MACHINE_NAME}, where it acts on that copy only
