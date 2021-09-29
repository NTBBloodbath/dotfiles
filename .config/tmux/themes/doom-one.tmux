#!/usr/bin/env bash
# doom-one colors for Tmux

set -g mode-style "fg=#21252a,bg=#51afef"

set -g message-style "fg=#21252a,bg=#51afef"
set -g message-command-style "fg=#21252a,bg=#51afef"

set -g pane-border-style "fg=#51afef"
set -g pane-active-border-style "fg=#21252a"

set -g status "on"
set -g status-justify "left"

set -g status-style "fg=#bbc2cf,bg=#21252a"

set -g status-left-length "100"
set -g status-right-length "100"

set -g status-left-style NONE
set -g status-right-style NONE

set -g status-left "#[fg=#21252a,bg=#51afef,bold] #S #[fg=#51afef,bg=#21252a,nobold,nounderscore,noitalics]"
set -g status-right "#[fg=#21252a,bg=#21252a,nobold,nounderscore,noitalics]#[fg=#a9a1e1,bg=#21252a] #{prefix_highlight} #[fg=#a9a1e1,bg=#21252a,nobold,nounderscore,noitalics]#[fg=#21252a,bg=#a9a1e1] %Y-%m-%d  %I:%M %p #[fg=#21252a,bg=#a9a1e1,nobold,nounderscore,noitalics]#[fg=#51afef,bg=#21252a,bold] #(who | cut -d \" \" -f1)@#h "

setw -g window-status-activity-style "underscore,fg=#a9a1e1,bg=#21252a"
setw -g window-status-separator ""
setw -g window-status-style "NONE,fg=#a9a1e1,bg=#21252a"
setw -g window-status-format "#[fg=#21252a,bg=#21252a,nobold,nounderscore,noitalics]#[default] #I  #W #F #[fg=#21252a,bg=#21252a,nobold,nounderscore,noitalics]"
setw -g window-status-current-format "#[fg=#21252a,bg=#a9a1e1,nobold,nounderscore,noitalics]#[fg=#21252a,bg=#a9a1e1,bold] #I  #W #F #[fg=#a9a1e1,bg=#21252a,nobold,nounderscore,noitalics]"

