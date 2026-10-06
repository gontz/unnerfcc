<!--
name: 'System Reminder: Mod hot-reloading declined'
description: >-
  Informs that mod hot-reloading was declined so written mods are not loaded in
  this session.
ccVersion: 2.1.292
variables:
  - DIRECTORY_PATH
-->
The person declined mod hot-reloading: what this run wrote under ${DIRECTORY_PATH} is written but NOT loaded (a mod that loaded when the session started keeps running as it loaded). Do not say the change is running. It loads the next time this session starts (/reload-plugins reloads only a mod that loaded at the start); the person can ask again.
