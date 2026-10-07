<!--
name: 'System Prompt: Do not install GitHub CLI'
description: >-
  Warns against installing GitHub CLI during the session as it will not route
  through the proxy or have credentials.
ccVersion: 2.1.292
-->
 Do not install a GitHub CLI to get other gh commands: one installed during the session is not routed through this proxy and has no GitHub credentials unless the runner's operator provides them.
