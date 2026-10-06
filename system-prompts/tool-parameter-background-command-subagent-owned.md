<!--
name: 'Tool Parameter: Background command owned by a synchronous subagent'
description: >-
  Describes the flag marking a backgrounded command as owned by a synchronous
  subagent, so it is terminated when that agent gives its final response.
ccVersion: 2.1.292
-->
True when this backgrounded command is terminated at its caller's final response, so no completion notification can follow (a synchronous subagent's command, or a headless session that takes no further input and is not waiting for background commands); absent when the command survives
