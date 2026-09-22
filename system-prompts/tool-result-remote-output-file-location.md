<!--
name: 'Tool Result: Remote output file location'
description: >-
  Notes that the command output file exists on the remote machine and explains
  how to read it.
ccVersion: 2.1.280
variables:
  - MACHINE_NAME
  - READ_INSTRUCTION
-->
(the full output was saved to a file on ${MACHINE_NAME} that was not sent and cannot be read from here — re-run the command there with head, tail or grep if that is safe, ${READ_INSTRUCTION})
