<!--
name: 'Tool Parameter: Artifact batch writes if_version pinning'
description: >-
  Explains if_version optimistic concurrency checking within batch write
  entries.
ccVersion: 2.1.292
-->
, plus if_version — that document's last-read `version`, required for every entry whose document already exists (omit it only when creating); if any pinned document has changed since, or an existing document's entry carries no pin, the whole batch writes nothing and the result names the first such entry
