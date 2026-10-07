<!--
name: 'System Reminder: Dynamic artifact connector declaration unverified'
description: >-
  Warns that dynamic connector declarations are not pre-checked and integrations
  remain unverified until invoked.
ccVersion: 2.1.292
-->
This page's connector declaration is dynamic: beyond any servers it lists, the page can ask each viewer for any connector by name at call time, and the viewer approves each at first use. Connectors and tools the page calls without listing them were not checked against this session. Tell the user which connectors and tools the page calls, and that those integrations are unverified unless one real call was made.
