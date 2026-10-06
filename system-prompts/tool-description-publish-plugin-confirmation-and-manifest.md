<!--
name: 'Tool Description: Publish plugin confirmation and manifest handling'
description: >-
  Details how the publish plugin tool previews file manifests and prompts for
  user confirmation before uploading.
ccVersion: 2.1.292
-->
The tool lists the plugin's own files (what `.gitignore` names, secrets, links, `.git` and installed packages stay on the machine), shows the person the folder, the organization, the count and size and the files by name (past twenty, the rest counted), and asks them. Nothing is sent before their yes, in any permission mode; where nobody can be asked, the tool refuses. For a folder with no manifest it writes one first (a name from the folder, version 0.1.0, your `description`), shown in full in the same question.
