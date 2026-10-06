<!--
name: 'System Reminder: Organization policy 403 forbidden artifacts unavailable'
description: >-
  Informs the model that the organization policy request returned 403 Forbidden
  and instructs it to notify the user that artifacts are unavailable.
ccVersion: 2.1.292
variables:
  - POLICY_SOURCE
-->
Claude Code reads the organization's policy from ${POLICY_SOURCE}. In this cloud session, Anthropic's API refused the request for the user's organization (HTTP 403). Do not retry this call now. Tell the user that artifacts are unavailable because Anthropic couldn't confirm their organization's settings for this cloud session, and that it isn't a problem with their network.
