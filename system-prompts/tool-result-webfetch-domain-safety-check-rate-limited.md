<!--
name: 'Tool Result: WebFetch domain safety check rate-limited'
description: >-
  Informs the model that domain safety checks are rate-limited and warns against
  retrying in a loop.
ccVersion: 2.1.292
variables:
  - DOMAIN
  - TOOL_NAME
-->
The safety check for domain ${DOMAIN} is rate-limited (too many domain checks from this network; the limit is shared and can stay exhausted for minutes). Do not retry ${TOOL_NAME} in a loop or sleep to wait it out; continue without this page and report that its safety check was rate-limited. A single later attempt is fine; if that is rate-limited too, stop.
