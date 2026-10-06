<!--
name: 'Tool Description: Project memory unavailable in session'
description: >-
  Instructs not to call project memory tools when unavailable in this session
  and directs to alternative paths.
ccVersion: 2.1.292
-->
- `project_memory_list`, `project_memory_read` — this tool does not serve project memory in this session, so do not call them. If this session offers memory tools, look for the project's memory files under `/projects/<project uuid>/` there.
