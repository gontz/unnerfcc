<!--
name: 'System Reminder: PreToolUse hook error in cloud session'
description: >-
  Notifies that a PreToolUse hook errored on a forwarded command and provides
  environment troubleshooting advice.
ccVersion: 2.1.292
-->
A PreToolUse hook on this machine exited with an error (whatever its cause) for a command your cloud session sent here and, as for a local command, did not block it. Note that hooks for such calls start in your home directory with a reduced environment: a guard that inspects the project must use $CLAUDE_PROJECT_DIR or the cwd field on stdin.
