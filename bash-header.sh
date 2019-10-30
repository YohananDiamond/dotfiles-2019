#!/usr/bin/env bash
#
# A simple header file imported by init.sh containing useful functions, mostly for startup.

pathappend() {
    # Appends the args to the PATH.
    for arg in "$@"; do
        if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
            PATH="${PATH:+"$PATH:"}$ARG"
        fi
    done
}

tmx() {
    # Run a tmux session or restore it
    [[ -n $1 ]] \
		&& (tmux attach -t $1 $2 &>/dev/null \
			|| tmux new-session -s $1 \; source-file ${DOTFILES}/sessions/$1.proj \; $2) \
	  || echo 'Usage: tmx setup-name <optional command>'
}

tquit() {
    # Send the quit command to all panes/windows/sessions on tmux
		tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index}' \
    | xargs -I PANE tmux send-keys -t PANE 'C-c' 'C-d' Enter
}
