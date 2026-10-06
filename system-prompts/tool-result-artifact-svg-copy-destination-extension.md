<!--
name: 'Tool Result: SVG copy destination must end in .svg'
description: >-
  Instructs that SVG images can only be copied to filenames ending with .svg or
  published locally.
ccVersion: 2.1.292
variables:
  - FOLLOW_UP_NOTE
-->
: an SVG image is copied only to a name ending .svg — copy it to a path ending .svg, or read it with action "read_file" and publish it from the local copy instead. Nothing was published.${FOLLOW_UP_NOTE}
