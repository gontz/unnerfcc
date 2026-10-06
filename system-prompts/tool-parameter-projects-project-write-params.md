<!--
name: 'Tool Parameter: Projects project_write parameters'
description: >-
  Parameter specification for project_write method requiring path and either
  content or local_path.
ccVersion: 2.1.292
-->
Pass `path` plus exactly one of `content` (inline text) or `local_path` (a file inside the working directory; the tool reads, encodes, and uploads it directly so its contents never enter your context — use this for anything you have on disk).
