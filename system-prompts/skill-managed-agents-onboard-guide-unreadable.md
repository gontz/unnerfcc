<!--
name: 'Skill: Managed agents onboard guide unreadable'
description: >-
  Informs the user that the guide cannot be read and asks to run the command
  again.
ccVersion: 2.1.292
variables:
  - QUICKSTART_NAME
  - GUIDE_FILE
  - TEMPLATE_CONTENT
-->
## Bundled Quickstarts

The request names the bundled quickstart `${QUICKSTART_NAME}`, included below. The guide that says how to build it (`${GUIDE_FILE}`) cannot be Read this session: show the user the template, write nothing, and ask them to run the command again.

${TEMPLATE_CONTENT}
