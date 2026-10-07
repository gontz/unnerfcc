<!--
name: 'Tool Result: Project write size limit exceeded'
description: >-
  Reports that a project_write was refused because it would exceed the project
  size limit.
ccVersion: 2.1.292
-->
Write refused; nothing in the project was changed. This write would put the project over its maximum size. Any doc already at this path still holds its old content; do not delete it to retry, because the retry can be refused too, and the content would then be lost. Do not delete other docs to make room unless the user asks. Tell the user the project is out of room: they can remove docs or files they no longer need, or ask you to write less.
