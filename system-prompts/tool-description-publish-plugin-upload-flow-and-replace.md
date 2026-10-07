<!--
name: 'Tool Description: Publish plugin upload flow and replace flag'
description: >-
  Explains the organization review flow and how to handle existing uploads with
  the replace flag.
ccVersion: 2.1.292
-->
On their yes the plugin is uploaded to the person's own shelf on claude.ai, scanned there, and submitted to the organization: an administrator reviews it, or it is published at once where the organization publishes without review. When the result says a plugin of this name is already in their uploads, ask the person whether to replace it, and only on their yes call again with `replace: true`.
