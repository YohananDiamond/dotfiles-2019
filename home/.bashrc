#!/usr/bin/env bash
#
# YohananDiamond's Bashrc

# CONSTANTS ######################################

if [[ -f ~/.config/_vars/DOTFILES ]]; then
    export DOTFILES=$(cat ~/.config/_vars/DOTFILES)
else
    export DOTFILES=~/git/dotfiles
fi
export COLUMNS # Make all processes know the amount of columns

export PLATFORM="std"
if [[ -r /sdcard ]]; then
  export PLATFORM="termux"
elif [[ -r "/mnt/c/Windows" ]]; then
  export PLATFORM="wsl"
fi

# HEADER FILES ###################################

. $DOTFILES/lib/bash-header.sh
. $DOTFILES/lib/bash-std.sh

if [[ -f ~/git/personal/lib/bash-pv.sh ]]; then 
    # Personal Scripts that I can't show here
    . ~/git/personal/lib/bash-pv.sh
fi

# INIT VARS ######################################

# Bash "first run in session" code
[[ -z "$FIRST" ]] && FIRST=0

test -r $DOTFILES/dircolors && eval "$(dircolors -b $DOTFILES/dircolors)" || eval "$(dircolors -b)"

# ALIASES & FUNCTIONS ############################

alias rebash='source $HOME/.bashrc'
alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -alF'
alias l='ls -CF'
alias cl='cd $@ && la'
alias py3='python3' 
alias ipy3='ipython'
alias du='du -shc'
alias rcp='rsync -aP'
alias rmv='rsync -aP --remove-source-files'

# Git-related
gsa() { for repo in ~/git/*; do pushd $repo; git s; popd &>/dev/null; done; }

# Directory variables and aliases for them
NOTES="$HOME/git/personal/notes"
TODO="$HOME/git/personal/todo"
REFL="$HOME/git/personal/notes/reference.mq"
alias vn='vi $NOTES'

# THEMING #######################################

# "less" config
export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;35m'     # begin blink
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\e[33m'       # begin reverse video
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\e[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline

# Prompt Config
# I've made it way simpler than before (I was using a kinda-glitchy python script I made)
set_prompt() {

    # Initial Colors
    local COL_RESET='\[\e[m\]'
    local COL_MAIN='\[\e[38;5;190m\]\[\e[48;5;237m\]'
    local COL_ALT='\[\e[38;5;180m\]\[\e[48;5;237m\]'

    # Increment PQ bit by bit.
    # PQ is the short for PROMPT_QUEUE
    local PQ=${COL_MAIN}' (\u)'${COL_RESET}
    local PQ=${PQ}${COL_ALT}' \w '${COL_RESET}
    local PQ=${PQ}' ' # Last space
    export PS1="$PQ"

}; set_prompt

# PATH ###########################################

pathappend "$HOME/.local/bin"
pathappend "$DOTFILES/bin"
pathappend "$DOTFILES/lib"

# FIRST LOAD CODE ###############################

if [[ $FIRST == 0 ]]; then

    FIRST=1

    # Start the "back" and "main" tmux sessions.
    # And also check if the program is running on a terminal.
    [[ -t 1 ]] && \
    [[ -z "$TMUX" ]] && [[ $PWD == $HOME ]] \
        && tmx back detach && tmx main

fi
