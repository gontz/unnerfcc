<!--
name: 'Tool Result: Server-side task moved to background'
description: >-
  Informs the model that a server-side task was moved to the background and will
  report results via notification upon completion.
ccVersion: 2.1.292
variables:
  - TASK_NAME
  - TASK_ID
  - CONTINUATION_NOTE
-->
" started server-side task ${TASK_NAME}. It was moved to the background as task ${TASK_ID} and keeps running on the server; you'll receive a notification with the result when it completes, and you can keep working in the meantime. ${CONTINUATION_NOTE}
