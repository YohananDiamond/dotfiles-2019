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
[[ -r /sdcard ]] && export PLATFORM="termux"

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

export EDITOR=nvim

# ALIASES & FUNCTIONS ############################

alias rebash='source $HOME/.bashrc'
alias vp="(cd $HOME/git/personal && vi)"
alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -alF'
alias l='ls -CF'
alias cl='cd $@ && la'
alias py3='python3' 
alias ipy3='ipython'
alias du='du -shc'
alias cps='cp -ur'
alias vi='nvim'
alias vim='nvim'

vs() {(
    # Open session.vim
    if [ -f Session.vim ]; then
        vi -S Session.vim # Open the vim session
    else
        cd $(git rev-parse --show-toplevel 2>/dev/null) # CD to the top of the git repository, if on the git repository.
        vi -S Session.vim
    fi
)}

cgt() {
    # CD to Git Top Level (cd-git-top)
    local result=$(git rev-parse --show-toplevel 2>/dev/null)
    if [ -z "${result}" ]; then
        cd "${result}"
    else
        echo "cgt: not on a git repository."
    fi
}

grept() {
    grep --exclude-dir=".git" -rEI "TODO:|FIXME:|@todo|@fixme" . 2>/dev/null
    grep --exclude-dir=".git" -rEI "NOTE:|@note" . 2>/dev/null
}

# Open files
if [[ ${PLATFORM} == "termux" ]]; then
    alias open='termux-open'
else
    alias open='xdg-open'
fi

# SETTINGS ######################################

# Larger History
export HISTSIZE=1000000
export HISTFILESIZE=1000000000

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
    local PQ=${COL_MAIN}' ($(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo \u))'${COL_RESET}
    local PQ=${PQ}${COL_ALT}' \w '${COL_RESET}
    local PQ=${PQ}' ' # Last space
    export PS1="$PQ"

}; set_prompt

# PATH ###########################################

pathappend "$HOME/.local/bin"
pathappend "$DOTFILES/bin"
pathappend "$DOTFILES/lib"
# [[ -r "/root/.cargo/bin" ]] && pathappend "/root/.cargo/bin" # For some reason it is not added automatically by rustup on my machine

# FIRST LOAD CODE ###############################

if [[ $FIRST == 0 ]]; then

    FIRST=1

    # Check if bash is running on interactive mode (graphically / on a terminal).
    if [[ -t 1 ]]; then

        # Start the "back" and "main" tmux sessions.
        [[ -z "$TMUX" ]] && [[ $PWD == $HOME ]] \
            && tmx back detach && tmx main

        # Set up fzf (lazy-coded)
        if ! [[ -r ~/.fzf ]]; then
            git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
        fi
        [[ -f ~/.fzf.bash ]] && source ~/.fzf.bash || source /usr/share/doc/fzf/examples/key-bindings.bash

    fi

fi

