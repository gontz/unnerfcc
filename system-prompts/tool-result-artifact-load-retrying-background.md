<!--
name: 'Tool Result: Artifact loading retrying in background'
description: >-
  Instructs the model not to retry loading an artifact immediately and to inform
  the user about potential network or IT proxy issues.
ccVersion: 2.1.280
-->
 and keeps retrying it in the background; whether artifacts are allowed is decided once it loads. Do not retry this call now. Tell the user why artifacts are unavailable and, if a proxy, VPN or web filter is involved, that their IT admin needs to let that address through.
