<!--
name: 'Tool Result: Remote re-announce retry guidance'
description: Guidance not to retry remote command until machine re-announces itself.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
-->
 Do not retry it on ${MACHINE_NAME} until ${MACHINE_NAME} re-announces, and do not call it again in this turn; continue with what you can do without it, and tell the user you could not confirm whether it 
