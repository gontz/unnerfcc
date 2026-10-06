<!--
name: 'Tool Result: Attachment network mount path unsupported'
description: Rejects attachments located under special or network mount paths.
ccVersion: 2.1.292
variables:
  - ATTACHMENT_PATH
-->
Attachment "${ATTACHMENT_PATH}" is under /net, /Network, /.vol, /.file, /.nofollow or /.resolve, which could trigger a network mount, so it is not supported. Copy the file to an ordinary local path and pass that path instead.
