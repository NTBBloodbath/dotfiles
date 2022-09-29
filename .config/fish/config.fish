# Plugins {{{
# Bootstrap fisher if not installed yet and install plugins {{{
if not functions -q fisher
   curl -sL git.io/fisher | source && fisher install jorgebucaran/fisher
   fisher update
end
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
