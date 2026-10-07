<!--
name: 'System Reminder: PDF removed for unsupported model'
description: >-
  Informs the user and model that a PDF was removed because the current model
  does not support PDF documents.
ccVersion: 2.1.292
variables:
  - FILE_NAME
-->
${FILE_NAME}: this model does not accept PDF documents, so a PDF in the conversation was removed. Ask Claude to read specific pages of the file instead (they are sent as images), or switch to a model that reads PDFs.
