<!--
name: 'Skill: Managed agents onboard unknown quickstart name'
description: >-
  Handles unrecognized quickstart names by presenting the list and asking the
  user.
ccVersion: 2.1.292
variables:
  - QUICKSTART_LIST
-->
${QUICKSTART_LIST}

The word after the subcommand in the request below is not one of these names. Show the list, say which is closest if one is, and ask. Don't build from a guess, and don't start the interview until they answer.
