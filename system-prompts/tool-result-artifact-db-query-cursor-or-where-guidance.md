<!--
name: 'Tool Result: Artifact db query cursor or filter guidance'
description: >-
  Advises paging with query.cursor or filtering with query.where when querying
  artifact collections.
ccVersion: 2.1.292
-->
Drop `query.order_by` and page with `query.cursor` to read them all, or narrow with `query.where`.
