# Navigation
#
# Go to previous directories
alias up="cd .."
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Editors
#
# Neovim
if command -qs nvim
   alias vi=nvim
end

# Emacs
if command -qs emacs
   alias em="emacsclient -c -t -a ''"
end

# Programming
#
# Zig
if command -qs zig
   alias zb="zig build --prominent-compile-errors"
   alias zr="zig run"
   alias zt="zig test"
   alias zfmt="zig fmt"
end

# Make
alias make="make -j $JOBS"

# Containers
#
if command -qs distrobox
   alias tbe="distrobox-enter --name env"
   alias tbd="distrobox-enter --name dev"
end

# Utilities
#
# Enable aliases to be sudo'ed
alias sudo=sudo

# Always use a valid $TERM value for SSH-ing
alias ssh="TERM=xterm-256color ssh"

# Saner defaults for some commands
alias df="df -h"
alias du="du -h"
alias grep="grep --color=auto"
alias watch="watch -pc"

# Reload the shell
alias reload="source $HOME/.config/fish/config.fish"

# Terminals
#
# Kitty
if command -qs kitty
   alias dcat="kitty +kitten diff"
   alias icat="kitty +kitten icat"

   if string match "kitty" $TERM
      alias ssh="kitty +kitten ssh"
   end
end

# vim: sw=3:ts=3:sts=3:ft=fish:fdm=marker:fdl=0
