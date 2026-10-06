<!--
name: 'Tool Parameter: Artifact database operations summary'
description: >-
  Comprehensive summary of database read and write actions and required
  parameters.
ccVersion: 2.1.292
-->
Reads: 'get' (one document: `collection` + `doc_id`), 'list' (a page of a collection: `collection`, with optional `query.limit`/`query.cursor`), 'query' (filtered: `collection` + `query`), 'profiles' (people's display names: `ids`, nothing else). Writes: 'set' (replace) or 'update' (merge) with `collection`, `doc_id`, and either `data` or `file_path`;
