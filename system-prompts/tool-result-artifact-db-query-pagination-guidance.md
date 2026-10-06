<!--
name: 'Tool Result: Artifact db query pagination and limit guidance'
description: >-
  Provides pagination guidance for artifact database queries using query.limit
  and query.cursor.
ccVersion: 2.1.292
variables:
  - MAX_LIMIT
-->
Pass `query.limit` (up to ${MAX_LIMIT}) for a larger page, or drop `query.order_by` and page with `query.cursor` to read them all.
