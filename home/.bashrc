#!/usr/bin/env bash

# EXPORTING ######################################

if [[ -f ~/.config/.vars/DOTFILES ]]; then
    export DOTFILES=$(cat ~/.config/.vars/DOTFILES)
else
    export DOTFILES=~/git/dotfiles
fi

export EDITOR="nvim"
export TERMINAL="gnome-terminal"

# HEADER FILES ###################################

. $DOTFILES/lib/bash-header.sh
. $DOTFILES/lib/bash-std.sh

# Personal Scripts that I can't show here
if [[ -f ~/git/personal/lib/bash-pv.sh ]]; then 
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
alias py3='python3' 
alias du='du -shc'
alias cps='cp -ur'
alias g='git'

# vi/vim/nvim aliases
alias vim='nvim' vi='nvim'
alias vp="(cd ${HOME}/git/personal && vi)"
alias vc="(cd ${DOTFILES} && vi)"

# fuzzy aliases
alias fpv='(cd ~/git/personal && vi $(find . | fzf))'
alias fv='vi $(find . | fzf)'
alias fc='cd "$(no-recursive-fuzzy-cd)"' # Available in dotfiles/bin
alias ft='grept | fzf'

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
if [[ -r /sdcard ]]; then
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

git-branch() {
    local branch="$(git symbolic-ref --short -q HEAD 2>/dev/null)"
    if [[ -n "${branch}" ]]; then
        echo " ${branch}"
    fi
}

# Prompt Config
# I've made it way simpler than before (I was using a kinda-glitchy python script I made)
__set_prompt() {

    # Set colors
    local _RESET='\[\e[m\]'
    local _BORDER='\[\e[31m\]'
    local _USER='\[\e[34m\]'
    local _BRANCH='\[\e[36m\]'
    local _PWD='\[\e[35m\]'
    # local _BORDER='\[\e[38;5;190m\]'
    # local _MAIN='\[\e[38;5;180m\]'
    # local _GITP='\[\e[38;5;33m\]'

    # Actually build the prompt
    local _PROMPT=''
    local _PROMPT+=${_BORDER}'['
    local _PROMPT+=${_USER}
    local _PROMPT+='\u:'
    local _PROMPT+=${_BRANCH}
    local _PROMPT+='$(git-branch)'
    local _PROMPT+=${_PWD}
    local _PROMPT+=' \w'
    local _PROMPT+=${_BORDER}']'
    local _PROMPT+=${_RESET}
    local _PROMPT+='\$ '
    export PS1="${_PROMPT}"

}; __set_prompt

# PATH ###########################################

path-append "${HOME}/.local/bin"
path-append "${DOTFILES}/bin"
path-append "${DOTFILES}/lib"

# FIRST LOAD CODE ################################

if [[ ${FIRST} == 0 ]]; then

    FIRST=1

    # Check if bash is running on interactive mode (graphically / on a terminal).
    if [[ -t 1 ]]; then

        # Start the "scratch" and "main" tmux sessions.
        if [[ -z "${TMUX}" ]]; then
            if (! tmux has -t="scratch" &>/dev/null); then
                tm "scratch" "detach"
            fi
            if [[ ${PWD} == ${HOME} ]] && (! tmux-attached "main"); then
                tm "main"
            fi
        fi

        # Set up FZF (may not work in every case, I need to check this someday)
        [[ -f ~/.fzf.bash ]] && source ~/.fzf.bash || source /usr/share/doc/fzf/examples/key-bindings.bash

    fi

fi

