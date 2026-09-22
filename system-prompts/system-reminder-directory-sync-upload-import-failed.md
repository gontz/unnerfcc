<!--
name: 'System Reminder: Directory sync upload import failed'
description: >-
  Informs the model that git repeatedly failed to import a specific upload from
  the user's machine.
ccVersion: 2.1.280
variables:
  - UPLOAD_NUMBER
-->
Directory sync: the user's newer changes are NOT here yet — git in this environment keeps failing to take in one of their machine's uploads (number ${UPLOAD_NUMBER}), so this turn runs on the files as they last synced here; the upload is tried again at every turn. Say so if the user refers to changes you cannot see here.
