<!--
name: 'Tool Parameter: Artifact batch writes commitment semantics'
description: >-
  Specifies single document addressing and atomic all-or-nothing batch
  commitment.
ccVersion: 2.1.292
-->
}. Each document is addressed at most once and the whole batch body is at most 1 MiB; the batch commits all-or-nothing where the server supports it, else 
