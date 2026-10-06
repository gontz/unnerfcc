<!--
name: 'Tool Description: Artifact device APIs with runtime capabilities'
description: >-
  Explains that device APIs require declared runtime capabilities and upload
  alternatives should be used otherwise.
ccVersion: 2.1.292
variables:
  - RUNTIME_CAPABILITIES_SKILL
-->
Camera, microphone, screen capture, location, motion, Web Share and similar device APIs are refused without a prompt — build on one only when this user has a runtime capability for that device (the `${RUNTIME_CAPABILITIES_SKILL}` skill lists them) and the page declares it; otherwise take photos, audio and data as uploaded files instead (file inputs, drag-and-drop of files and `FileReader` work in browsers). A screen wake lock may be granted while the page is visible: request it and tolerate rejection.
