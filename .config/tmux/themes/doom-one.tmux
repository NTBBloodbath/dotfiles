#!/usr/bin/env bash
# doom-one colors for Tmux

set -g mode-style "fg=#21242b,bg=#51afef"

set -g message-style "fg=#21242b,bg=#51afef"
set -g message-command-style "fg=#21242b,bg=#51afef"

set -g pane-border-style "fg=#51afef"
set -g pane-active-border-style "fg=#21242b"

set -g status "on"
set -g status-bg "#21242b"
set -g status-justify "left"

set -g status-style "fg=#bbc2cf,bg=#21242b"

set -g status-left-length "100"
set -g status-right-length "100"

set -g status-left-style NONE
set -g status-right-style NONE

set -g status-left "#[fg=#21242b,bg=#51afef,bold] #S #[fg=#51afef,bg=#21242b,nobold,nounderscore,noitalics]"
set -g status-right "#[fg=#21242b,bg=#21242b,nobold,nounderscore,noitalics]#[fg=#a9a1e1,bg=#21242b] #{prefix_highlight} #[fg=#a9a1e1,bg=#21242b,nobold,nounderscore,noitalics]#[fg=#21242b,bg=#a9a1e1] %Y-%m-%d  %I:%M %p #[fg=#21242b,bg=#a9a1e1,nobold,nounderscore,noitalics]#[fg=#51afef,bg=#21242b,bold] #(who | cut -d \" \" -f1)@#h "

setw -g window-status-activity-style "underscore,fg=#a9a1e1,bg=#21242b"
setw -g window-status-separator ""
setw -g window-status-style "NONE,fg=#a9a1e1,bg=#21242b"
setw -g window-status-format "#[fg=#21242b,bg=#21242b,nobold,nounderscore,noitalics]#[default] #I  #W #F #[fg=#21242b,bg=#21242b,nobold,nounderscore,noitalics]"
setw -g window-status-current-format "#[fg=#21242b,bg=#a9a1e1,nobold,nounderscore,noitalics]#[fg=#21242b,bg=#a9a1e1,bold] #I  #W #F #[fg=#a9a1e1,bg=#21242b,nobold,nounderscore,noitalics]"

