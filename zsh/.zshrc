# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


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


### ZSH Configurations ###
## General
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

## Jobs
# Report status of background jobs immediately
setopt notify
# Don't run all background jobs at a lower priority
unsetopt bg_nice
# Don't kill jobs on shell exit
unsetopt hup
# Don't report on jobs when shell exit
unsetopt check_jobs

## Completion
# Complete from both ends of a word
setopt complete_in_word
# Move cursor to the end of a completed word
setopt always_to_end
# Perform path search even on command names with slashes
setopt path_dirs
# Show completion menu on a successive tab press
setopt auto_menu
# Automatically list choices on ambiguous completion
setopt auto_list
# If completed parameter is a directory, add a trailing slash
setopt auto_param_slash

## History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=5000
setopt appendhistory notify
unsetopt beep nomatch
# Treat the '!' character specially during expansion
setopt bang_hist
# Write to the history file immediately, not when the shell exits
setopt inc_append_history
# Share history between all sessions
setopt share_history
# Expire a duplicate event first when trimming history
setopt hist_expire_dups_first
# Don't record an event that was just recorded again
setopt hist_ignore_dups
# Delete an old recorded event if a new event is a duplicate
setopt hist_ignore_all_dups
# Don't display a previously found event
setopt hist_find_no_dups
# Don't record an event starting with a space
setopt hist_ignore_space
# Don't write a duplicate event to the history file
setopt hist_save_no_dups
# Don't execute immediately upon history expansion
setopt hist_verify
# Show timestamp in history
setopt extended_history


### User configurations ###
# Export custom PATH
export PATH=$HOME/.local/bin:$HOME/go/bin:$XDG_$PATH

# XDG_DATA_HOME
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}

# Editor
export EDITOR=nvim

# Store your own aliases in your $HOME directory and load them here
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# Start lenv (Lua version manager)
source ~/.lenvrc

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Blur kitty terminal {{{
if [[ $(ps --no-header -p $PPID -o comm) =~ '^kitty$' ]]; then
    for wid in $(xdotool search --pid $PPID); do
        xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id $wid;
    done
fi
# }}}


### Plugins & themes ###
# I use the OMZ key-bindings, so I do not have to keymap my HOME, END, etc keys
zinit wait lucid light-mode for \
    atinit"zicompinit; zicdreplay" \
        zdharma/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
        zsh-users/zsh-completions \
    MichaelAquilina/zsh-auto-notify \
    zdharma/history-search-multi-word \
    OMZ::lib/key-bindings.zsh

# jeffreytse/zsh-vi-mode \

zinit ice from'gitlab'
zinit load code-stats/code-stats-zsh

# powerlevel10k theme
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Zoxide ZSH integration
eval "$(zoxide init zsh)"
