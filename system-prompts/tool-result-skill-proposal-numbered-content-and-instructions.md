<!--
name: 'Tool Result: Numbered skill content for update proposal'
description: >-
  Displays the existing numbered SKILL.md content and instructs calling again
  with the complete file.
ccVersion: 2.1.292
variables:
  - SKILL_NAME
  - ALTERNATIVE_ACTION
  - SKILL_CONTENT_BLOCK
-->
${SKILL_NAME} is not in this conversation. A saved proposal replaces the whole file, so here it is, each line after its number and a tab, which are not part of the file; call again with a complete SKILL.md that keeps everything worth keeping, or ${ALTERNATIVE_ACTION}.${SKILL_CONTENT_BLOCK}
