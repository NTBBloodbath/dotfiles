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

# Update Neovim
alias viup="make distclean && make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=$HOME/.local/nvim install"

# Emacs
if command -qs emacs
   alias em="emacsclient -c -t -a ''"
end

# Utilities
#
# Improve make
alias make="make -j$JOBS"

# Always use a valid $TERM value for SSH-ing
# alias ssh="TERM=xterm-256color ssh"

# Saner defaults for some commands
alias df="df -h"
alias du="du -h"
alias grep="grep --color=auto"
alias watch="watch -pc"

# Reload the shell
alias reload="source $HOME/.config/fish/config.fish"

# Spawn BASH with the system profile (I am spawning fish from my bashrc to keep POSIX stuff happy)
alias bash="bash --rcfile /etc/profile"

# Reboot to UEFI
alias uefi_reboot="systemctl reboot --firmware-setup"

# MongoDB
#
# Turn off using `mongosh` and typing `db.shutdownServer()` command on it
if command -qs mongod
   alias start_mongo="mongod --config /usr/local/etc/mongod.conf --fork"
end

# vim: sw=3:ts=3:sts=3:ft=fish:fdm=marker:fdl=0
