<!--
name: 'Tool Result: Artifact verifier select element disallowed'
description: >-
  Informs that select elements are not allowed in artifact HTML and advises
  mocking the control with lists or buttons.
ccVersion: 2.1.292
-->
<select> is not allowed — browsers and this verifier parse its contents differently, so markup inside it would go uninspected. Mock up the control with a list or buttons instead.
