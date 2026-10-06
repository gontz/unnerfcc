<!--
name: 'System Reminder: Mod hot-reloading pending /reload-plugins'
description: >-
  Informs that mod hot-reloading was enabled but mods await /reload-plugins to
  avoid rewriting prompt cache.
ccVersion: 2.1.292
variables:
  - DIRECTORY_PATH
-->
The person enabled mod hot-reloading for this session, but the mods under ${DIRECTORY_PATH} wait for /reload-plugins (the load would rewrite the prompt cache): they are NOT loaded yet.
