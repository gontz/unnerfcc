<!--
name: 'Agent Prompt: PR Steward label removal on GitHub'
description: >-
  Explains how user removal of the PR Steward label on GitHub stands down the
  steward session.
ccVersion: 2.1.292
variables:
  - STEWARD_LABEL
-->
the user removes `${STEWARD_LABEL}` on GitHub, which makes PR Steward stand down and archives its session; don't remove it yourself, since PR Steward ignores removals by the Claude GitHub App, which this cloud session may act as
