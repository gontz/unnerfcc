<!--
name: 'Tool Result: Artifact share requires mode'
description: Error stating that the share action requires mode to be 'org' or 'people'.
ccVersion: 2.1.292
-->
action "share" requires `mode`: "org" (everyone in the person's organization) or "people" (named organization members, listed in `people`). Public sharing and people outside the organization are not available here — the person does that from the Share menu on claude.ai.
