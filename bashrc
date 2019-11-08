#!/usr/bin/env bash

# CONSTANTS ######################################

export DOTFILES=$(dirname $BASH_SOURCE)
export COLUMNS # Make all processes know the amount of columns

export PLATFORM="std"
if [[ -r /sdcard ]]; then
  export PLATFORM="termux"
elif [[ -r "/mnt/c/Windows" ]]; then
  export PLATFORM="wsl"
fi

# HEADER FILES ###################################

. $DOTFILES/bash-header.sh

# INIT VARS ######################################

# Bash "first run in session" code
[[ -z "$FIRST" ]] && FIRST=0

test -r $DOTFILES/dircolors && eval "$(dircolors -b $DOTFILES/dircolors)" || eval "$(dircolors -b)"

# ALIASES ########################################

alias rbash='source $HOME/.bashrc'
alias ls='ls --color=auto'
alias la='ls -A $@'
alias ll='ls -alF $@'
alias l='ls -CF $@'
alias cl='cd $@ && la'
alias py3='python3 $@'
alias ipy3='ipython $@'
alias du='du -shc'
alias rscp='rsync -aP'
alias rsmv='rsync -aP --remove-source-files'

# Git aliases
alias gh='echo ALIASES -> gs gpp gc gl'
alias gpp='git pull && git push'
alias gs='git status --short'
alias gc='git add . && git commit'
alias gl='git log --oneline'
gsa() { for repo in ~/git/*; do pushd $repo; gs; popd &>/dev/null; done; }

# Directory variables and aliases for them
NOTES="$HOME/git/personal/notes"
TODO="$HOME/git/personal/todo"
REFL="$HOME/git/personal/notes/reference.mq"
alias vn='vi $NOTES'

# THEMING #######################################

# "less" config
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;35m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[33m'       # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# "prompt" config
# I'm experiencing a bug where I have an error because of this line when logging in on Ubuntu. I'm taking a look at it.
PS1=$(python3 $DOTFILES/bin/prompt)
PS2='\[\033[48;5;240m\]\[\033[38;5;253m\] ... \[\033[m\] '

# PATH ###########################################

pathappend "$HOME/.local/bin"
pathappend "$DOTFILES/bin"

# FIRST LOAD CODE ###############################

if [[ $FIRST == 0 ]]; then

    FIRST=1

    # Start the "back" and "main" tmux sessions.
    [[ -z "$TMUX" ]] && [[ $PWD == $HOME ]] \
        && tmx back detach && tmx main

fi
