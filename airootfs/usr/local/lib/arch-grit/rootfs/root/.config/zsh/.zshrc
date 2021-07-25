###################################################
#						  #
#	ZSHRC (sourced when interactive)	  #
#						  #
###################################################

# For interactive customization.  Ex: Prompt, aliases,
# color output, keybindings, history, completions, etc.


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.config/zsh/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# Completions
zstyle :compinstall filename "~/.config/zsh/.zshrc"
autoload -Uz compinit
compinit

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

##################### Aliases

##### sudo fix for alias'
alias sudo='sudo '

# dockerctl script
alias dockerctl='/home/docker/bin/dockerctl'

##### dd
alias dd='dd bs=4M status=progress oflag=sync'

##### Color output
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias grep='grep --color=auto'


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
