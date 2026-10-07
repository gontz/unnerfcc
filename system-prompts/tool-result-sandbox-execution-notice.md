<!--
name: 'Tool Result: Sandbox execution notice'
description: >-
  Informs the model that a command ran inside the sandbox on the target machine
  and explains restriction scope.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
-->
This command ran on ${MACHINE_NAME} inside Claude Code's sandbox, which is switched on there. The sandbox can block network connections and file writes outside the working directories.
