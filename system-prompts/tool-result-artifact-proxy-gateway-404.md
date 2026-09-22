<!--
name: 'Tool Result: Artifact proxy gateway 404 error'
description: >-
  Instructs the model not to retry loading an artifact when a proxy or gateway
  returns 404, and to advise contacting IT.
ccVersion: 2.1.280
-->
, and a proxy or gateway that does not forward that path will keep answering 404, so nothing in this session can load it. Do not retry this call. Tell the user that their IT admin needs to let that address through to the API.
