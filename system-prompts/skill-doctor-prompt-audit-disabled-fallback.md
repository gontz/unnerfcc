<!--
name: 'Skill: Doctor prompt audit disabled fallback'
description: >-
  Fallback prompt when /doctor prompt-audit cannot run because claude-api skill
  is disabled.
ccVersion: 2.1.292
-->
I ran `/doctor prompt-audit`, which hands off to the bundled claude-api skill's prompt audit. That skill is not available in this session: it is disabled, set to off in the skillOverrides setting, or turned off with every other bundled skill by the disableBundledSkills setting or CLAUDE_CODE_DISABLE_BUNDLED_SKILLS. Tell me that in a sentence or two, including that undoing whichever applies restores the audit, and stop there.
