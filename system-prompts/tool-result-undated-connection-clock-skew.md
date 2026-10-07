<!--
name: 'Tool Result: Undated connection clock skew notice'
description: >-
  Notice that a request reached the machine over an undated connection whose
  currency cannot be verified.
ccVersion: 2.1.292
variables:
  - REQUEST_TYPE
  - MACHINE_NAME
  - REASON
-->
${REQUEST_TYPE} reached ${MACHINE_NAME} over a connection that could not be dated against the service's clock, so whether it is still current is unknown — ${REASON}
