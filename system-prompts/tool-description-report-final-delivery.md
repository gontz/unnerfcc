<!--
name: 'Tool Description: Final report delivery tool'
description: >-
  Describes the tool used by a subagent to deliver its final report to its
  caller upon completion.
ccVersion: 2.1.292
variables:
  - REPORT_TOOL_NAME
-->
Deliver your final report to the agent that spawned you (your caller). Use it once, for that hand-off only: when your work is complete, call ${REPORT_TOOL_NAME}({message: <your full report>}). The call ends your run, so do everything else first and put everything your caller needs in that one report. It is not a messaging channel: do not use it for progress updates or questions.

Only a report delivered through ${REPORT_TOOL_NAME} reaches your caller; plain text you write at the end of your run is NOT delivered. There is no recipient parameter: the report can only go to your caller.
