<!--
name: 'Tool Description: Bash sandbox local port binding failure guidance'
description: >-
  Guides handling local port binding EPERM failures in the sandbox via
  sandbox.network.allowLocalBinding.
ccVersion: 2.1.292
-->
If a command fails to bind or listen on a local port with "Operation not permitted" (EPERM), local port binding is off in this sandbox. Treat it as the sandbox-caused failure described above, and tell the user that `sandbox.network.allowLocalBinding: true` in their settings (it applies without a restart) allows it without leaving the sandbox.
