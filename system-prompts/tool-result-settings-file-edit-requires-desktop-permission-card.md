<!--
name: 'Tool Result: Settings file change requires desktop app approval'
description: >-
  Informs the model that settings file edits in the desktop app apply only with
  user permission card approval.
ccVersion: 2.1.292
variables:
  - SETTINGS_FILE_PATH
-->
Not applied: ${SETTINGS_FILE_PATH} was NOT modified. In the Claude desktop app, a change to a Claude Code settings file applies only when the user approves that edit on its permission card. Tell the user what you meant to change. Do not retry the edit or try to make the same change another way.
