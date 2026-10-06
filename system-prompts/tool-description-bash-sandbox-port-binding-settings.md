<!--
name: 'Tool Description: Bash sandbox local port binding settings decision'
description: >-
  Instructs informing the user about sandbox.network.allowLocalBinding when port
  binding fails.
ccVersion: 2.1.292
variables:
  - SETTINGS_NOTE
-->
If a command fails to bind or listen on a local port with "Operation not permitted" (EPERM), local port binding is off in this sandbox. Tell the user they can allow it with `sandbox.network.allowLocalBinding: true` in their settings (it applies without a restart)${SETTINGS_NOTE}; changing sandbox settings is their decision, not yours.
