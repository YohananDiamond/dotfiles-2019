#!/usr/bin/env bash

# ENVIRONMENT VARIABLES ##########################

export DOTFILES="${HOME}/git/dotfiles"
export GIT_PERSONAL="${HOME}/git/personal"
export EDITOR="nvim"
export TERMINAL="st"
export BAT_THEME="base16" # Theme for bat (cat with syntax highlighting)

# SOURCING ########################################

source_if() { [ -f "${1}" ] && source "${1}"; }

source "${DOTFILES}/lib/bash-header.sh"
source "${DOTFILES}/lib/bash-std.sh"

# Personal and local scripts
source_if "${GIT_PERSONAL}/lib/bash-pv.sh"
source_if "${HOME}/.bashrc.local"

# APPLICATION SETTINGS ###########################

# bash
export HISTSIZE=1000000
export HISTFILESIZE=1000000000

# less | man
export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;35m'     # begin blink
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\e[33m'       # begin reverse video
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\e[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline

# ls | dir
test -r "${DOTFILES}/config/dircolors" \
    && eval "$(dircolors -b "${DOTFILES}/config/dircolors")" \
    || eval "$(dircolors -b)"

# PATH ###########################################

path_add "${HOME}/.local/bin"
path_add "${DOTFILES}/bin"
path_add "${DOTFILES}/lib"

# ALIASES ########################################

alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -alF'
# alias l='ls -CF'

alias py3='python3'
alias p3='python3'
alias jl='julia'
alias du='du -shc'
alias r='ranger'
alias vim='nvim' vi='nvim'
# alias g='git'

alias cp-sync='cp -ur'

# USER FUNCTIONS #################################
# These functions were designed to be used in ####
# the shell; because of that, they should have ###
# dashes '-' instead of underscores '_'. #########

rl() { source "${HOME}/.bashrc"; }
vp() { (cd "${GIT_PERSONAL}" && vi); }
vf() { vi "$(find . | fzf)"; }
# cdr() { cd "$(no-recursive-fuzzy-cd)"; }

rd() {
    local CHOICEPATH="${HOME}/Documents/html-pages"
    local CHOICE="$(ls "${CHOICEPATH}" | grep '\.html$' | fzf)"
    open "${CHOICEPATH}/${CHOICE}" &
}

vs() {
    ([ -f "Session.vim" ] \
        && vi -S "Session.vim" \
        || cd "$(git rev-parse --show-toplevel 2>/dev/null)" \
        && vi -S "Session.vim")
}

cdgt() {
    # CD to Git Top Level (cd-git-top)
    local result=$(git rev-parse --show-toplevel 2>/dev/null)
    [ -z "${result}" ] && cd "${result}" \
        || echo "cgt: not on a git repository."
}

grept() {
    grep --exclude-dir=".git" -rEI "TODO:|FIXME:|@todo|@fixme" . 2>/dev/null
    grep --exclude-dir=".git" -rEI "NOTE:|@note" . 2>/dev/null
}

if [ -r "/sdcard" ]; then
    open() { termux-open "${1}"; } # No need for "& true" here.
else
    open() { xdg-open "${1}"; }
fi

# THEMING #######################################

git-branch() {
    local branch="$(git symbolic-ref --short -q HEAD 2>/dev/null)"
    if [[ -n "${branch}" ]]; then
        echo " ${branch}"
    fi
}

# PROMPT CONFIG ##################################

__set_prompt() {

    # Set colors
    local _RESET='\[\e[m\]'
    local _BORDER='\[\e[31m\]'
    local _USER='\[\e[34m\]'
    local _BRANCH='\[\e[36m\]'
    local _PWD='\[\e[35m\]'

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

if [ -z "${__SETUP}" ]; then
    __SETUP="$(date)"
    if [ -t 1 ]; then # If this session is a TTY
        # Start the "scratch" and "main" tmux sessions.
        if [ -z "${TMUX}" ]; then
            if ! tmux has -t="scratch" &>/dev/null; then
                tm "scratch" "detach"
            fi

            if [ "${PWD}" = "${HOME}" ] && ! tmux-attached "main"; then
                tm "main"
            fi
        fi

        # Set up FZF (may not work in every case, I need to check this someday)
        [[ -f ~/.fzf.bash ]] && source ~/.fzf.bash || source /usr/share/doc/fzf/examples/key-bindings.bash

    fi
fi
