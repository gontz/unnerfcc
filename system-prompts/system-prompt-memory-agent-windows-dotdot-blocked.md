<!--
name: 'System Prompt: Memory agent Windows parent directory traversal blocked'
description: Warns memory agent against using parent directory traversal on Windows.
ccVersion: 2.1.292
-->
On Windows with permissions.blockReadsOutsideWorkingDirectories on, the memory agent's shell commands may not contain '..' anywhere, even split by quotes or a backslash, because where it leads cannot be checked. Use absolute paths, and avoid '..' in patterns too.
