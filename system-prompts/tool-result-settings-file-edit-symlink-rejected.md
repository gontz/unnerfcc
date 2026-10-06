<!--
name: 'Tool Result: Settings file edit rejected via symlink'
description: >-
  Informs the model that approved settings edits are rejected when accessed
  through a symbolic link.
ccVersion: 2.1.292
variables:
  - SETTINGS_FILE_PATH
-->
Not applied: ${SETTINGS_FILE_PATH} was NOT modified. The user approved this edit on its permission card, but this path reaches a Claude Code settings file through a symbolic link, so the approval does not apply it. Tell the user what you meant to change. Do not retry the edit or try to make the same change another way.
