<!--
name: 'System Reminder: Background command timeout restart guidance'
description: >-
  Advises restarting a timed-out background process with a longer timeout if
  needed or reporting that it stopped.
ccVersion: 2.1.292
-->
If the work in progress still needs it, start it again with `run_in_background` and a longer `timeout`. If it already had the longest `timeout` allowed, do not restart it. Either way, report that it was stopped.
