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

#+--- Pane Borders ---+
set -g pane-border-style fg='#21242b'
set -g pane-active-border-style fg='#51afef'

#+--- Bars ---+
set -g status-style bg="#21242b",fg="#bbc2cf"
set -g status-interval 1

#+--- Bars Left ---+
# Session name
set -g status-left "#[fg=#21242b,bg=#51afef,bold] #S #[fg=#51afef,bg=#21242b,nobold,noitalics,nounderscore]"
#+--- Windows ---+
# Focus
set -g window-status-current-format "#[fg=#bbc2cf,bg=#282c34]   #I #W  "
# Unfocused
set -g window-status-format "#[fg=#bbc2cf,bg=#5b6268,nobold,noitalics,nounderscore]   #I #W #F  "

#+--- Bars Right ---+
set -g status-right "#[fg=#bbc2cf,bg=#5b6268] %Y-%m-%d #[]❬ %H:%M $git_status"
set -g window-status-separator ""
