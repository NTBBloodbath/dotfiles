# Plugins {{{
# Bootstrap fisher if not installed yet and install plugins {{{
#if not functions -q fisher
#   curl -sL git.io/fisher | source && fisher install jorgebucaran/fisher
#   fisher update
#end
# }}}

# Set up tide theme {{{
if functions -q tide
   # Prompt character icon
   set -g tide_character_icon λ

   # Left prompt items
   set -g tide_left_prompt_items distrobox context $tide_left_prompt_items

   # Right prompt items
   set -g tide_right_prompt_items status cmd_duration jobs time
end
# }}}

# FZF {{{
if functions -q fzf_configure_bindings
   # Set FZF headers
   set -g fzf_dir_opts --header="Search file"
   set -g fzf_git_log_opts --header="Git logs"
   set -g fzf_git_status_opts --header="Git status"
   set -g fzf_shell_vars_opts --header="Search shell variables"
   set -g fzf_processes_opts --header="Search processes"
   set -g fzf_history_opts --header="Search fish history"

   set fzf_fd_opts --hidden --exclude=.git --exclude=.cache --exclude=node_modules --exclude=__pycache__ --exclude=zig-cache

   # Use eza if possible for directory preview command
   if command -qs eza
      set fzf_preview_dir_cmd eza --all --color=always
   end

   # Use cat if bat is not available
   if not command -qs bat
      set fzf_preview_file_cmd cat
   end
end
# }}}
# }}}

# Personal configurations {{{
# Remove fish greeting
set -U fish_greeting

# Use vi mode by default, can be disabled by using fish_default_key_bindings
fish_vi_key_bindings

# Load aliases, environment variables, etc
source $HOME/.config/fish/env.fish
source $HOME/.config/fish/abbrev.fish
source $HOME/.config/fish/aliases.fish
test -e $XDG_CONFIG_HOME/fish/tk.fish && source $XDG_CONFIG_HOME/fish/tk.fish
# }}}

# vim: sw=3:ts=3:sts=3:ft=fish:fdm=marker:fdl=0
