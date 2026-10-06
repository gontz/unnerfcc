<!--
name: 'Tool Result: Project write NUL bytes rejected'
description: >-
  Refuses project_write when content contains NUL bytes, directing conversion to
  UTF-8 text.
ccVersion: 2.1.292
-->
Write refused; nothing in the project was changed. The content contains NUL bytes, which project docs cannot store (usually a binary or UTF-16 file). Convert it to UTF-8 text (re-encode UTF-16, extract the text from a binary, or remove the NUL bytes), then write again.
