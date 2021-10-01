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
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$ZINIT_HOME/bin/zinit.zsh" && \
        command chmod g-rwX "$ZINIT_HOME/bin/zinit.zsh" 
    command git clone https://github.com/zdharma/zinit "$ZINIT_HOME/bin" && \
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
# Treat the '!' character specially during expansion
setopt bang_hist
# Write to the history file immediately, not when the shell exits
setopt inc_append_history
# Delete an old recorded event if a new event is a duplicate
setopt hist_ignore_all_dups
# Don't display a previously found event
setopt hist_find_no_dups
# Don't write a duplicate event to the history file
setopt hist_save_no_dups
# }}}
# }}}

# {{{ User configurations
# Export custom PATH
export LBIN=$HOME/.local/bin
export EBIN=$HOME/.config/emacs/bin
export LROCKSBIN=$HOME/.luarocks/bin
export SUPERMANBIN=$HOME/.local/share/nvim/site/pack/packer/opt/vim-superman/bin
export PATH=$LBIN:$EBIN:$LROCKSBIN:$SUPERMANBIN:$PATH

# XDG directories
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

# Editor
export EDITOR=nvim

# Language
export LANG=en_us.UTF-8

# Tokens and API keys
[[ ! -f $XDG_CONFIG_HOME/zsh/tk.zsh ]] || source $XDG_CONFIG_HOME/zsh/tk.zsh

# Use Neovim as the man pager
export MANPAGER="nvim +Man!"

# Start lenv (Lua version manager)
[[ ! -f $HOME/.lenvrc ]] || source $HOME/.lenvrc

# Load the most recently selected theme automatically (using theme.sh)
# if command -v theme.sh > /dev/null; then
# 	export THEME_HISTFILE=~/.theme_history
# 	[ -e "$THEME_HISTFILE" ] && theme.sh "$(theme.sh -l|tail -n1)"
# fi

# {{{ Blur kitty terminal
if [[ $(ps --no-header -p $PPID -o comm) =~ '^kitty$' ]]; then
    for wid in $(xdotool search --pid $PPID); do
        xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id $wid;
    done
fi
# }}}
# }}}

# {{{ Plugins & themes

# {{{ p10k theme
zinit ice depth=1; zinit light romkatv/powerlevel10k
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
      zdharma/fast-syntax-highlighting \
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
      zdharma/history-search-multi-word \
    hlissner/zsh-autopair
# }}}

# {{{ Snippets
zinit ice wait lucid
zinit snippet $XDG_CONFIG_HOME/zsh/aliases
# }}}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $XDG_CONFIG_HOME/zsh/p10k.zsh ]] || source $XDG_CONFIG_HOME/zsh/p10k.zsh

# }}}

# vim: fdm=marker sw=2 ts=2
