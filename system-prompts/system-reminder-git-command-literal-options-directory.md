<!--
name: 'System Reminder: Spell git options literally and run from directory'
description: >-
  Instructs the model to spell git subcommands literally and run them from the
  specified directory.
ccVersion: 2.1.292
variables:
  - WORKING_DIRECTORY
-->
Spell git's options and subcommand out literally, quoting any pattern meant for git itself, and run it from ${WORKING_DIRECTORY}.
