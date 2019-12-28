#!/usr/bin/env bash
#
# A simple header file imported by init.sh containing useful functions, mostly for startup.

path_add() {
    # Appends the args to the PATH.
    for ARG in "$@"; do
        if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
            export PATH="${PATH:+"$PATH:"}$ARG"
        fi
    done
}

tmux-attached() {
    # Checks if a session is attached
    if [[ -n "$1" ]]; then
        tmux ls | grep "^$1.*(attached)\$" &>/dev/null
    else
        echo -e '\e[34mUsage:\e[m tmux-attached SESSION-NAME'
    fi
}

tm() {
    # Start a tmux session or reattach to it.
    if [[ -n "$1" ]]; then
        if tmux has -t="$1" &>/dev/null; then
            tmux attach -t "$1"
        else
            tmux new-session -s "$1" \; source-file "${DOTFILES}/lib/tmux-sessions/$1.proj" \; $2
        fi
    else
        echo -e '\e[34mUsage:\e[m tm SESSION-NAME <optional-command>'
    fi
}
