<!--
name: 'System Reminder: Directory sync checkout failed'
description: >-
  Informs the model that recent changes could not be synced into the local
  checkout and re-upload was requested.
ccVersion: 2.1.280
variables:
  - FAILURE_REASON
-->
Directory sync: the user's latest changes could not be brought into this checkout (${FAILURE_REASON}); the user's files stay as they last were here, if any, and their machine has been asked to send its current files again. Say so if the user expects those changes to be here already.
