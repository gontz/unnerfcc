<!--
name: 'Tool Description: SearchPlugins return format'
description: >-
  Describes the ranked list return format and follow-up card rendering for
  SearchPlugins.
ccVersion: 2.1.280
-->
Returns a ranked list with id, name, description, and whether the plugin is already enabled for this session (in a channel session, whether the channel has it). When results fit and SuggestPluginInstall is among your tools, call it to render the install card; otherwise relay the relevant results in text instead. If nothing relevant, proceed without mentioning that you searched.
