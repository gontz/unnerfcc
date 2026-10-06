<!--
name: 'Tool Description: ScheduleWakeup pacing for interval-less loop'
description: >-
  Describes using ScheduleWakeup to pace dynamic /loop executions without a
  fixed interval.
ccVersion: 2.1.292
variables:
  - FALLBACK_TOOL_NAME
-->
schedules when this session resumes work, 60 to 3600 seconds from now. Use it, not ${FALLBACK_TOOL_NAME}, to pace a /loop that has no interval.
