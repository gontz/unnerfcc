<!--
name: 'Tool Result: Cloud review stopped externally'
description: >-
  Informs the model that a cloud review was stopped externally and instructs not
  to start another review unless asked.
ccVersion: 2.1.280
-->
It was stopped from claude.ai or another Claude client, or ended by the server. Tell the user that plainly; they can run the review again if they did not stop it themselves. Do not start another review, cloud or local, unless the user asks.
