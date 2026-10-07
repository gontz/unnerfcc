<!--
name: 'Tool Result: Managed policy settings edit rejected'
description: >-
  Informs the model that edits to managed policy settings files or --settings
  files are rejected despite user card approval.
ccVersion: 2.1.292
variables:
  - SETTINGS_FILE_PATH
-->
Not applied: ${SETTINGS_FILE_PATH} was NOT modified. The user approved this edit on its permission card, but this path is, or may be, a managed policy settings file or the --settings file, so the approval does not apply it. Tell the user what you meant to change. Do not retry the edit or try to make the same change another way.
