<!--
name: 'Tool Result: Remote background command running details'
description: >-
  Details for a background command launched on a remote machine, including log
  location, monitoring rules, and sandbox isolation caveats.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
  - COMMAND_ID
  - OUTPUT_PATH
  - TIMEOUT_DURATION
-->
Command running in the background on ${MACHINE_NAME} with ID: ${COMMAND_ID}. Output is being written there to: ${OUTPUT_PATH}. This session is not notified when it finishes. Whether it is still running is told by ${MACHINE_NAME} itself: not by that file, which holds only what the command has printed (a program that buffers its output shows it there only when it flushes), and never by pgrep, ps, pkill or a network request from a later command, because where ${MACHINE_NAME} sandboxes commands each command sees only its own processes and its own network, so a command that is running looks absent from there. It is stopped after ${TIMEOUT_DURATION} in the background, or earlier if ${MACHINE_NAME} stops serving this session.
