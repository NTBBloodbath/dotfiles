# Set GPG TTY in Termux, solve issues while signing commits
[[ -n "$TERMUX_VERSION" ]] && export GPG_TTY="$TTY"

# {{{ p10k instant prompt
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# }}}

# {{{ Zinit bootstrap
export ZINIT_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/zinit"
### Added by Zinit's installer
if [[ ! -f "$ZINIT_HOME/bin/zinit.zsh" ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}ZINIT%F{220} Plugins Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$ZINIT_HOME" && \
        command chmod g-rwX "$ZINIT_HOME" 
    command git clone --depth 1 https://github.com/zdharma-continuum/zinit "$ZINIT_HOME/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$ZINIT_HOME/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk
# }}}

# {{{ ZSH Options
# {{{ General
# Load colors
autoload -U colors && colors
# Use Case-Insensitive globbing
unsetopt case_glob
# Use extended globbing
setopt extendedglob
# Automatically cd if a directory is entered
setopt autocd
# make cd push the old directory onto the directory stack
setopt auto_pushd
# No beep
setopt no_beep
# Recognize comments
setopt interactivecomments
# }}}

# {{{ Jobs
# Report status of background jobs immediately
setopt notify
# Don't run all background jobs at a lower priority
unsetopt bg_nice
# Don't kill jobs on shell exit
unsetopt hup
# Don't report on jobs when shell exit
unsetopt check_jobs
# }}}

# {{{ Completion
# Perform path search even on command names with slashes
setopt path_dirs
# Automatically list choices on ambiguous completion
# setopt auto_list
# If completed parameter is a directory, add a trailing slash
setopt auto_param_slash
# }}}

# {{{ History
HISTFILE="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/zsh_history"
setopt appendhistory notify
unsetopt beep nomatch
# Do not treat the '!' character specially during expansion
setopt no_bang_hist
# Write to the history file immediately, not when the shell exits
setopt inc_append_history
# Delete an old recorded event if a new event is a duplicate
setopt hist_ignore_all_dups
# Don't display a previously found event
setopt hist_find_no_dups
# Don't write a duplicate event to the history file
setopt hist_save_no_dups
# Add timestamps to history
setopt extended_history
# Share history between sessions
setopt share_history
# }}}
# }}}

# {{{ User configurations
# Export custom PATH
export PATH=$HOME/.local/bin:$PATH
if [[ -d "$HOME/.config/emacs/bin" ]]; then
  export PATH=$HOME/.config/emacs/bin:$PATH
fi
if [[ -d "$HOME/.luarocks/bin" ]]; then
  export PATH=$HOME/.luarocks/bin:$PATH
fi
if [[ -d "$HOME/.local/zig/current" ]]; then
  export PATH=$HOME/.local/zig/current:$PATH
fi
# if [[ -d "$HOME/.stack/programs/x86_64-linux" ]]; then
#   export PATH=$HOME/.stack/programs/x86_64-linux/ghc-tinfo6-8.10.7/bin:$PATH
# fi

# XDG directories
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}

# Editor
export EDITOR=nvim

# Language
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Tokens and API keys
[[ ! -f "$XDG_CONFIG_HOME/zsh/tk.zsh" ]] || source "$XDG_CONFIG_HOME/zsh/tk.zsh"

# Use Neovim as the man pager
export MANPAGER="nvim +Man!"

# Source Lua version manager and clone it if not found on system
export LUVER_DIR="${XDG_DATA_HOME:-"$HOME/.local/share"}/luver"
if [[ ! -d "${LUVER_DIR}/self" ]]; then
  git clone --quiet --depth 1 https://github.com/MunifTanjim/luver.git "$LUVER_DIR/self"
fi

[[ ! -f "$LUVER_DIR/self/luver.plugin.zsh" ]] || source "$LUVER_DIR/self/luver.plugin.zsh"

# Load XMake profile
[[ -s "$HOME/.xmake/profile" ]] && source "$HOME/.xmake/profile"

# Load the most recently selected theme automatically (using theme.sh)
# if command -v theme.sh > /dev/null; then
# 	export THEME_HISTFILE=~/.theme_history
# 	[ -e "$THEME_HISTFILE" ] && theme.sh "$(theme.sh -l|tail -n1)"
# fi

# {{{ Blur kitty terminal
# if [[ "$TERM" == "xterm-kitty" ]]; then
#   if [[ $(ps --no-header -p $PPID -o comm) =~ '^kitty$' ]]; then
#     for wid in $(toolbox run --container env xdotool search --pid $PPID); do
#       xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id $wid;
#     done
#   fi
# fi
# }}}
# }}}

# {{{ Plugins & themes

# {{{ Snippets
zinit ice wait lucid
zinit snippet $XDG_CONFIG_HOME/zsh/aliases
# }}}

# {{{ p10k theme
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Custom functions
distrobx() {
  if [ -f /run/.containerenv ]; then
    local _distrobox_name="$(cat /run/.containerenv | awk -F= '$1=="name" { print $2 }' | tr -d '"')"
    echo -n "%{%F{magenta}%}⬢ %{%F{white}%}$_distrobox_name%{%f%}"
  fi
}

# }}}

setopt promptsubst

# {{{ OMZ stuff
# Load OMZ plugins and libs first as some of these sets some defaults which
# are required later on. Otherwise something will look messed up.

# OMZ libs
zinit wait lucid for \
  atinit'HIST_STAMPS=dd.mm.yyyy' \
    OMZL::history.zsh \
  OMZL::key-bindings.zsh \
  OMZL::spectrum.zsh \
  OMZL::termsupport.zsh \
  OMZL::git.zsh
# }}}

# {{{ Plugins
# These plugins should be loaded after OMZ plugins
zinit wait lucid light-mode for \
    atinit'
      typeset -gA FAST_HIGHLIGHT;
      ZINIT[COMPINIT_OPTS]=-C;
      zicompinit; zicdreplay;
    ' \
      zdharma-continuum/fast-syntax-highlighting \
    atload'!_zsh_autosuggest_start' \
      zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
    atinit'
      zstyle ":completion:*" completer _expand _complete _ignored _approximate
      zstyle ":completion:*" matcher-list "m:{a-z}={A-Z}"
      zstyle ":completion:*" menu select=2
      zstyle ":completion:*" select-prompt "%SScrolling active: current selection at %p%s"
      zstyle ":completion:*:descriptions" format "-- %d --"
      zstyle ":completion:*:processes" command "ps -au$USER"
      zstyle ":completion:complete:*:options" sort false
      zstyle ":fzf-tab:complete:_zlua:*" query-string input
      zstyle ":completion:*:*:*:*:processes" command "ps -u $USER -o pid,user,comm,cmd -w -w"
      zstyle ":fzf-tab:complete:kill:argument-rest" extra-opts --preview=$extract"ps --pid=$in[(w)1] -o cmd --no-headers -w -w" --preview-window=down:3:wrap
      zstyle ":fzf-tab:complete:cd:*" extra-opts --preview=$extract"exa -1 --color=always ${~ctxt[hpre]}$in"
    ' \
      zsh-users/zsh-completions \
    atinit'
      zstyle :history-search-multi-word page-size 10
      zstyle :history-search-multi-word highlight-color fg=blue,bold
      zstyle :plugin:history-search-multi-word reset-prompt-protect 1
    ' \
      zdharma-continuum/history-search-multi-word \
    hlissner/zsh-autopair

# zinit ice depth=1
# zinit light jeffreytse/zsh-vi-mode
# {{{ ZSH Vi Mode setup
# Use jk to exit insert mode 
# ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
# }}}

# }}}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $XDG_CONFIG_HOME/zsh/p10k.zsh ]] || source $XDG_CONFIG_HOME/zsh/p10k.zsh
POWERLEVEL9K_CUSTOM_DISTROBOX="distrobx"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(custom_distrobox dir vcs newline)

# }}}

# {{{ Cursor shape (Termux)
if [[ -n "$TERMUX_VERSION" ]]; then
  _change_cursor() {
    # Block
    # echo -ne '\e[2 q'
    # Underline
    # echo -ne '\e[4 q'
    # Bar
    echo -ne '\e[6 q'
  }
  precmd_functions+=(_change_cursor)
fi
# }}}

# vim: fdm=marker sw=2 ts=2
