<!--
name: 'Skill: Artifact endpoint verification rule'
description: >-
  Instructs checking declared endpoints with get_endpoints and calling each GET
  route once.
ccVersion: 2.1.280
-->
for declared endpoints, `get_endpoints` once and one `call_endpoint` on each GET route (a writing route only when the user wants a test record made)
