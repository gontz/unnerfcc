<!--
name: 'Tool Result: File exceeds byte limit, use view_range'
description: >-
  Error returned when reading a file that exceeds the byte limit, advising the
  use of view_range.
ccVersion: 2.1.292
variables:
  - MAX_BYTES_LIMIT
-->
 bytes, exceeds ${MAX_BYTES_LIMIT}-byte limit. Use the view_range parameter to read specific line ranges, e.g. view_range: [1, 500].
