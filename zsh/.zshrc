# {{{ Zinit bootstrap
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
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
HISTFILE="$HOME/.zsh_history"
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
export PATH=$HOME/.local/bin:$HOME/go/bin:$HOME/.config/emacs/bin:$PATH

# XDG_DATA_HOME
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}

# Editor
export EDITOR=nvim

# Start lenv (Lua version manager)
source ~/.lenvrc

# {{{ Blur kitty terminal
if [[ $(ps --no-header -p $PPID -o comm) =~ '^kitty$' ]]; then
    for wid in $(xdotool search --pid $PPID); do
        xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id $wid;
    done
fi
# }}}
# }}}

# {{{ Plugins & themes
# {{{ OMZ stuff
# Load OMZ plugins and libs first as some of these sets some defaults which
# are required later on. Otherwise something will look messed up.

setopt prompt_subst

# OMZ libs
zinit wait lucid for \
  atinit'HIST_STAMPS=dd.mm.yyyy' \
    OMZL::history.zsh \
  OMZL::compfix.zsh \
  OMZL::correction.zsh \
  OMZL::git.zsh \
  OMZL::key-bindings.zsh \
  OMZL::spectrum.zsh \
  OMZL::termsupport.zsh

# OMZ plugins
zinit wait lucid for \
  OMZP::command-not-found \
  OMZP::dnf \
  OMZP::gitignore
# }}}

# {{{ Plugins
# These plugins should be loaded after OMZ plugins
zinit wait lucid light-mode for \
    atinit'
      typeset -gA FAST_HIGHLIGHT;
      FAST_HIGHLIGHT[git-cmsg-len]=100;
      zicompinit;
      zicdreplay;
    ' \
      zdharma/fast-syntax-highlighting \
    atinit'ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20' \
    atload'_zsh_autosuggest_start' \
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
    MichaelAquilina/zsh-auto-notify \
    hlissner/zsh-autopair \
    from'gitlab' \
      code-stats/code-stats-zsh

# }}}

## {{{ ZSH Pure theme
# Setup
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

### Configuration
## General
# Max execution time of a process before its run is shown when it exits.
# Time in seconds.
PURE_CMD_MAX_EXEC_TIME=30
## GIT
# Prevents Pure from checking wheter the current Git remote has been updated.
PURE_GIT_PULL=1
# Do not include untracked files in dirtiness check. Mostly useful on large
# repoitories.
PURE_GIT_UNTRACKED_DIRTY=1
# Time in seconds to delay git dirty checking when `git status` takes more
# than 5 seconds.
PURE_GIT_DELAY_DIRTY_CHECK=1800
# Turn on `git stash` command status.
zstyle :prompt:pure:git:stash show yes
# }}}

# {{{ Snippets
zinit ice wait lucid
zinit snippet $HOME/.aliases
# }}}
# }}}

# vim: ft=zsh fdm=marker sw=2 ts=2
