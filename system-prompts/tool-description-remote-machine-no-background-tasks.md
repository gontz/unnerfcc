<!--
name: 'Tool Description: Remote machine background tasks unsupported'
description: >-
  Warns that background tasks cannot be polled on attached machines and must run
  in foreground or locally.
ccVersion: 2.1.280
variables:
  - NOTE_PREFIX
-->
${NOTE_PREFIX} The calling session has no way to poll a background task there. Run it in the foreground, or in the session's own environment.
