<!--
name: 'System Reminder: Command check disabled after repeated prompts'
description: >-
  Informs that a command check was disabled after prompting the user three times
  in a row.
ccVersion: 2.1.292
variables:
  - CHECK_COMMAND
-->
This project's command check (${CHECK_COMMAND}) needed the person's OK three times in a row on this computer, so it is not run again for this session and each command asks instead. If it could not finish there, make it work read-only (no writes outside $TMPDIR, no network, no tools installed under the home directory).
