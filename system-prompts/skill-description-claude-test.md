<!--
name: 'Skill Description: Claude Test'
description: >-
  Skill description for running Claude Test specs in a fenced headless browser
  against the local dev server.
ccVersion: 2.1.292
-->
Checks that the web app in this repo still works — plain-language specs in .claude-test/specs/ run in the background in a fenced headless browser against the local dev server, and a PASS / FAIL summary comes back with screenshots. On a first run it proposes a starter set of specs for the person to approve. Use when the user asks ("test my app", "did I break anything?", "run claude test"). When the user asks for it. Unasked, only in a project that already has .claude-test/specs/ and only after a change a person can see in the app — then OFFER to run it in one line; never start it, or begin setup, on your own. Skip for docs-only or test-only changes.
