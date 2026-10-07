<!--
name: 'Tool Description: Artifact device APIs refused'
description: >-
  Explains that device APIs are refused without prompt and features should take
  file uploads instead.
ccVersion: 2.1.292
-->
Camera, microphone, screen capture, location, Web Share and similar device APIs are refused without a prompt — don't build features on them (a screen wake lock may be granted while the page is visible: request it and tolerate rejection); file inputs, drag-and-drop of files and `FileReader` work in browsers, so take photos, audio and data as uploaded files instead.
