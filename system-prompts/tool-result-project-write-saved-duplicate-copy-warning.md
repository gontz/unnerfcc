<!--
name: 'Tool Result: Project write saved duplicate copy warning'
description: >-
  Warns that earlier copy was not deleted upon overwriting and instructs user to
  remove duplicate in claude.ai.
ccVersion: 2.1.292
-->
project_write: the new content was saved, but the earlier copy of this doc may not have been removed, so the project may now list this path twice. project_read returns the new content. Do not repeat this write, and do not call project_delete: it would remove the new content, not the earlier copy. Tell the user that the earlier copy may need removing from the project in claude.ai.
