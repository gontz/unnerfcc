<!--
name: 'Tool Result: Machine does not serve tool'
description: >-
  Informs the model that the selected machine does not serve the tool and
  indicates which machine does.
ccVersion: 2.1.280
variables:
  - REQUESTED_MACHINE
  - TOOL_NAME
  - SERVING_MACHINE
  - MACHINE_PARAM
-->
${REQUESTED_MACHINE} does not serve ${TOOL_NAME}, and this session's own environment has none; ${SERVING_MACHINE} serves it — set "${MACHINE_PARAM}" to "${SERVING_MACHINE}" or omit it. Nothing ran.
