# Language {{{
# set -x LC_ALL en_US.UTF-8
# set -x LC_CTYPE en_US.UTF-8
set -x LANG en_US.UTF-8
# }}}

# Custom PATH {{{
#
set -l paths "$HOME/.local/bin"
set -a paths "$HOME/.bun/bin"
set -a paths "$HOME/.local/julia/bin"
set -a paths "$HOME/.local/zig/current"
set -a paths "$HOME/.luarocks/bin"
set -a paths "$HOME/.lenv/current/bin"
set -a paths "$HOME/.lenv/current/luarocks/3.9.1/bin"

# Set PATH and avoid duplicates when spawning a terminal in Neovim
for path in $paths
   if not contains $path $PATH
      set PATH $path $PATH
   end
end

# Print PATH to stdout
function print_path
	for _path in $PATH
		echo "entry: $_path"
	end
end
# }}}

# XDG directories {{{
#
# Data
set -Ux XDG_DATA_HOME "$HOME/.local/share"

# Config
set -Ux XDG_CONFIG_HOME "$HOME/.config"

# State
set -Ux XDG_STATE_HOME "$HOME/.local/state"

# Cache
set -Ux XDG_CACHE_HOME "$HOME/.cache"
# }}}

# Clean $HOME {{{
#
# ADB
set -Ux ANDROID_HOME "$XDG_DATA_HOME/android"

# GPG
# set -Ux GNUPGHOME "$XDG_DATA_HOME/gnupg"

# GTK
set -Ux GTK2_RC_FILES "$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

# Cursors
# set -Ux XCURSOR_PATH "$XDG_DATA_HOME/icons" $XCURSOR_PATH

# KDE
# set -Ux KDEHOME "$XDG_CONFIG_HOME/kde"

# Pager
set -Ux LESSHISTFILE "$XDG_STATE_HOME/less/history"

# MySQL
set -Ux MYSQL_HISTFILE "$XDG_DATA_HOME/mysql_history"

# Terminfo
set -Ux TERMINFO "$XDG_DATA_HOME/terminfo"
set -Ux --path TERMINFO_DIRS "$XDG_DATA_HOME/terminfo" /usr/share/terminfo

# NodeJS
set -Ux NODE_REPL_HISTORY "$XDG_DATA_HOME/node_repl_history"
set -Ux NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"
# }}}

# Utilities {{{
#
# Editor
set -Ux EDITOR "nvim"

# Use Neovim as the man pager
set -Ux MANPAGER "nvim +Man!"

# Elixir's IEX shell history
set -Ux ERL_AFLAGS "-kernel shell_history enabled"

# FZF options
set -Ux FZF_DEFAULT_OPTS "\
   +i +s --ansi --exact --header-first --color=16 --tabstop=4 --border=rounded --info=inline\
   --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
   --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
   --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# LESS with colors
# from http://blog.0x1fff.com/2009/11/linux-tip-color-enabled-pager-less.html
set -Ux LESS "-RSM~gIsw"

# Set GPG TTY, solve issues while signing commits
# if set -q TERMUX_VERSION
set -x GPG_TTY $(tty)
# end

# Processor cores
# Use only half of cores, this is for limiting the melting of my processor
set -Ux CORES $(nproc)
set -Ux JOBS (math $CORES / 2)
# }}}

# vim: sw=3:ts=3:sts=3:ft=fish:fdm=marker:fdl=0
