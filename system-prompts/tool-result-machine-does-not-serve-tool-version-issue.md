<!--
name: 'Tool Result: Machine does not serve tool version issue'
description: >-
  Informs the model that the machine does not currently serve the tool, possibly
  due to a restart or older version.
ccVersion: 2.1.280
variables:
  - MACHINE_NAME
  - TOOL_NAME
-->
${MACHINE_NAME} does not serve ${TOOL_NAME} right now (its Claude Code there may have restarted without it, or be an older version), and this session's own environment has no ${TOOL_NAME}; nothing ran.
