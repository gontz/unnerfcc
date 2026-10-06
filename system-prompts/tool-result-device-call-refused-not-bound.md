<!--
name: 'Tool Result: Device call refused not bound'
description: >-
  Error returned when a device tool call is refused because the device is not
  bound to the session.
ccVersion: 2.1.292
variables:
  - TOOL_NAME
-->
${TOOL_NAME} refused: this device is not bound to the session (it registered without a device id). Start the cloud session from this machine with claude --cloud so it registers as a bound device.
