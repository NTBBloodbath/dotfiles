#!/usr/bin/env bash
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# title      Tokyo Night                                              +
# version    1.0.0                                                    +
# repository https://github.com/logico-dev/tokyo-night-tmux           +
# author     Lógico                                                   +
# email      hi@logico.com.ar                                         +
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
set -g status-right-length 150

# Replace the location of the script.
git_status="#(~/.config/tmux/themes/tokyo-night/git-status.sh #{pane_current_path})"

#+--- Bars LEFT ---+
# Session name
set -g status-left "#[fg=black,bg=blue,bold] #S #[fg=blue,bg=black,nobold,noitalics,nounderscore]"
#+--- Windows ---+
# Focus
set -g window-status-current-format "#[fg=white,bg=#1F2335]   #I #W  "
# Unfocused
set -g window-status-format "#[fg=brightwhite,bg=blue,nobold,noitalics,nounderscore]   #I #W #F  "

#+--- Bars RIGHT ---+
set -g status-right "#[fg=white,bg=#24283B] %Y-%m-%d #[]❬ %H:%M $git_status"
set -g window-status-separator ""
