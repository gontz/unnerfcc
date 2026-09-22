<!--
name: 'System Reminder: Attached machine git fetch and review'
description: >-
  Instructions for fetching and reviewing branch commit SHAs on an attached
  machine.
ccVersion: 2.1.280
variables:
  - MACHINE_PARAM_FLAG
  - MACHINE_NAME
  - DIFF_COMMAND
-->
 calls with "${MACHINE_PARAM_FLAG}" from its project folder (${MACHINE_NAME}'s own rules decide whether each runs or the user is asked first): run "git fetch --no-tags origin <branch>" and nothing more, then "git rev-parse refs/remotes/origin/<branch>": the full commit id it prints, written <sha> below, is what the user reviews and the only name anything later may use for this work — a branch or tag name can be moved or shadowed after the review, a commit id cannot. Show the user that id and the output of two commands before anything else. First "${DIFF_COMMAND}": everything the branch changes (keep every option and use the commit id: without the -c ones and --ignore-submodules=none the user's git settings can hide paths or print an odd character raw, and --raw prints every path whole however long it is, after its old and new file mode). Then "
