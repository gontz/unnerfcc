<!--
name: 'Skill: update-config reload UI menu guidance'
description: >-
  Instructs telling the user to open the settings UI menu to reload config or
  restart session.
ccVersion: 2.1.292
variables:
  - CONFIG_COMMAND_OR_MENU
-->
Tell the user to open `${CONFIG_COMMAND_OR_MENU}` once (reloads config) or restart — you can't do this yourself; `${CONFIG_COMMAND_OR_MENU}` is a user UI menu and opening it ends this turn.
