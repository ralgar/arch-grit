############################################
###   ZSHRC (sourced when interactive)   ###
############################################


#######################################
###   INITIALIZATION AND SETTINGS   ###
#######################################
# Load P10K Theme, and P10K Instant Prompt
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Create Zsh cache dir for history / completions
if [[ ! -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh" ]] ; then
  mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
fi

# Basic Settings
unsetopt beep
bindkey -e

# History
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
setopt inc_append_history
setopt extended_history
setopt hist_ignore_all_dups

# Completions
zstyle :compinstall filename "$ZDOTDIR/.zshrc"
fpath=('/opt/git-subrepo/share/zsh-completion' $fpath)
autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compdump"

# Source aliases and functions
. "$ZDOTDIR/aliases"
. "$ZDOTDIR/functions"
. "$ZDOTDIR/ssh-agent"
