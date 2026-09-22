<!--
name: 'Skill: Artifact capability page as record'
description: >-
  Explains using the artifact capability when the page itself serves as the
  persistent record.
ccVersion: 2.1.280
-->
- The page itself is the record (a poll, a sign-up sheet, a checklist): the `artifact` capability — a viewer who can write republishes the whole page from its state; every open view reloads to the winner, a concurrent save rejects `conflict`, and read-only viewers cannot save. Such a page regenerates the whole document from its state: keep the head, tokens and structure and change only the content.
