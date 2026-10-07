<!--
name: 'Skill: Code Review (findings JSON schema)'
description: JSON format schema for code review findings ordered by severity.
ccVersion: 2.1.292
-->
:

```json
[
  {
    "file": "path/to/file.ext",
    "line": 123,
    "summary": "one-sentence statement of the bug",
    "failure_scenario": "concrete inputs/state → wrong output/crash"
  }
]
```

Ranked most-severe first. 
