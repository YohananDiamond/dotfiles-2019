#!/usr/bin/env bash

# CONSTANTS ######################################

export INITFILES=$(dirname $BASH_SOURCE)
export DOTFILES=$(dirname $INITFILES)
export COLUMNS # Make all processes know the amount of columns

export PLATFORM="std"
if [[ -r /sdcard ]]; then
  export PLATFORM="termux"
elif [[ -r "/mnt/c/Windows" ]]; then
  export PLATFORM="wsl"
fi

# HEADER FILES ###################################

. $INITFILES/header.sh

# INIT VARS ######################################

# Bash "first run in session" code
[[ -z "$FIRST" ]] && FIRST=0

# ALIASES ########################################

alias rbash='source $HOME/.bashrc'
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

# APP THEMING ####################################

# "less" config
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;35m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[33m'       # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# prompt config
PS1=$(py3 $INITFILES/bin/prompt)
PS2='\[\033[1;37;45m\] ... \[\033[m\] '

# PATH ###########################################

pathappend "$HOME/.local/bin"
pathappend "$INITFILES/bin"

#

# A temporary git thing. Not very easy to use.
g() {
    if [[ -n $1 ]]; then
        for x in $1/*; do
            echo $'\e[36m' "In repository $x"
            cd $x
            git status --short
            cd ..
        done
    else
        local NUL=0
        git pull
        printf "Press ENTER to continue: "
        read NUL
        git add .
        git commit
    fi
}

# FIRST LOAD CODE ###############################

if [[ $FIRST == 0 ]]; then

    FIRST=1

    # Start the "back" and "main" tmux sessions.
    [[ -z "$TMUX" ]] && [[ $PWD == $HOME ]] \
        && tmx back detach && tmx main

fi
