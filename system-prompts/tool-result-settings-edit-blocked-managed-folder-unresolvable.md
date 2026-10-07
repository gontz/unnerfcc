<!--
name: 'Tool Result: Settings edit blocked managed folder unresolvable'
description: >-
  Informs the model that a write was refused because the managed settings folder
  location could not be verified.
ccVersion: 2.1.292
variables:
  - FILE_PATH
-->
Not written: ${FILE_PATH} was NOT modified. Claude Code could not resolve where its managed settings folder is, so it cannot rule out that this path is a managed settings file, and it does not write the file. Tell the user what you meant to change. Do not retry the edit or try to make the same change another way.
