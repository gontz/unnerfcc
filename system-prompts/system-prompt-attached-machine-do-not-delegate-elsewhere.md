<!--
name: 'System Prompt: Do not delegate machine-exclusive work'
description: Warns against delegating machine-exclusive resources to other machines.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
-->
 work to another machine unless the task belongs there: what is only on ${MACHINE_NAME} is not on the others.
