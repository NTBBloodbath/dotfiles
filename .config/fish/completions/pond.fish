set -l commands_without_options_single_pond status dir config autoload autounload
set -l commands_without_options_multiple_pond load unload enable disable check
set -l commands_with_options remove drain list
set -l commands "create $commands_without_options_single_pond $commands_without_options_multiple_pond $commands_with_options"

# Disable file completion as no subcommand requires a file path
complete -c pond -f

# Complete commands if no subcommand has been given so far
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a create -d 'Create a new pond'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a autoload -d 'Create or edit pond autoload function'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a autounload -d 'Create or edit pond autounload function'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a remove -d 'Remove a pond and associated data'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a list -d 'List ponds'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a check -d 'Check pond functions for syntax issues'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a enable -d 'Enable a pond for new shell sessions'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a disable -d 'Disable a pond for new shell sessions'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a load -d 'Load pond into current shell session'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a unload -d 'Unload pond from current shell session'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a status -d 'View pond status'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a drain -d 'Drain all data from pond'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a dir -d 'Change current working directory to pond'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -a config -d 'Show configuration settings'

# Complete options for list command
complete -c pond -n "__fish_seen_subcommand_from list; and not __fish_seen_subcommand_from -e --enabled" -a "-e --enabled" -d "List enabled ponds"
complete -c pond -n "__fish_seen_subcommand_from list; and not __fish_seen_subcommand_from -d --disabled" -a "-d --disabled" -d "List disabled ponds"
complete -c pond -n "__fish_seen_subcommand_from list; and not __fish_seen_subcommand_from -l --loaded" -a "-l --loaded" -d "List loaded ponds"
complete -c pond -n "__fish_seen_subcommand_from list; and not __fish_seen_subcommand_from -u --unloaded" -a "-u --unloaded" -d "List unloaded ponds"

# Complete pond name for commands that do not support options but accept a single pond name
complete -c pond -n "__fish_seen_subcommand_from $commands_without_options_single_pond; and not __fish_seen_subcommand_from (pond list 2>/dev/null)" -a "(pond list 2>/dev/null)"

# Complete pond name for commands that do not support options but accept multiple pond names
complete -c pond -n "__fish_seen_subcommand_from $commands_without_options_multiple_pond" -a "(pond list 2>/dev/null)"

# Complete options or pond name for remove command
complete -c pond -n "__fish_seen_subcommand_from remove; and not __fish_seen_subcommand_from -y --yes; and not __fish_seen_subcommand_from (pond list 2>/dev/null)" -a "-y --yes" -d "Automatically accept confirmation prompts"
complete -c pond -n "__fish_seen_subcommand_from remove" -a "(pond list 2>/dev/null)"

# Complete options or pond name for drain command
complete -c pond -n "__fish_seen_subcommand_from drain; and not __fish_seen_subcommand_from -y --yes; and not __fish_seen_subcommand_from (pond list 2>/dev/null)" -a "-y --yes" -d "Automatically accept confirmation prompts"
complete -c pond -n "__fish_seen_subcommand_from drain" -a "(pond list 2>/dev/null)"

# Complete long and short options
complete -c pond -n "not __fish_seen_subcommand_from $commands" -s h -l help -d 'Print a short help text and exit'
complete -c pond -n "not __fish_seen_subcommand_from $commands" -s v -l version -d 'Print a short version string and exit'
