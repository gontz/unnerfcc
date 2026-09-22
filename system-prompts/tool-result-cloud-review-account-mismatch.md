<!--
name: 'Tool Result: Cloud review account mismatch'
description: >-
  Informs the model that a cloud review may belong to a different account and
  explains how the user can re-attach it.
ccVersion: 2.1.280
-->
Tell the user that plainly. If they signed in to a different account or organization, the review may still finish under the one that started it; signing back in as that account first and then resuming this conversation (claude --resume) re-attaches it if it is still there. Do not start another review, cloud or local, unless the user asks.
