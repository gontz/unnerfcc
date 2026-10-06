<!--
name: 'Tool Result: Remote no action taken tell user'
description: >-
  Notice that no action was taken on the machine and advising telling the user
  rather than retrying.
ccVersion: 2.1.292
variables:
  - MACHINE_NAME
-->
 Nothing was done for it on ${MACHINE_NAME}. Sending it again will not change that: tell the user instead of retrying.
