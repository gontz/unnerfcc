<!--
name: 'Skill: update-config hook live menu pointer'
description: >-
  Instructs confirming the hook is live and pointing the user to the config UI
  menu to manage it.
ccVersion: 2.1.292
variables:
  - CONFIG_COMMAND_OR_MENU
-->
Tell the user the hook is live (or needs `${CONFIG_COMMAND_OR_MENU}`/restart per the watcher caveat). Point them at `${CONFIG_COMMAND_OR_MENU}` to review, edit, or disable it later.
