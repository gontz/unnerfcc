<!--
name: 'Data: Artifact publish multi-call updates'
description: >-
  Instructs publishing remaining files across subsequent calls with matching url
  and root.
ccVersion: 2.1.292
-->
 and publish them with the same `url` and `root` — all in one more call, or a few files per call as you go (`file_path`: one new file's absolute path, `files`: the other new ones) — each call carrying only files no earlier call sent (each publish keeps the files earlier calls sent); 
