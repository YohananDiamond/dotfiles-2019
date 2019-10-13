#!/usr/bin/env bash
# Bash Dotfiles
# Author: YohananDiamond
# 
# Note: most custom commands are under the "wd" command
# and most options are under the "wdx" command.
#
# (TODO) Finish NA

#############
# CONSTANTS #
#############

# The directory of this path
WD_InitPath=$(dirname $BASH_SOURCE)

# Current Platform
# (TODO) Improve this. It looks kinda flawled and hard to use.
[[ -r "/sdcard" ]] && WD_Platform="termux" \
	|| [[ -r "/mnt/c/Windows" ]] && WD_Platform="wsl" \
	|| WD_Platform="regular"

#############
# INIT VARS #
#############

# Bash "first run in session" code
[[ -z "$WD_FirstRun" ]] && WD_FirstRun=0

#############
# FUNCTIONS #
#############

# import: run .sh files inside this directory.
import() {

	# Function name for error prompting
	local FunctionName="import"

	# Verify if the input is okay
	[[ "$1" == "" ]] && echo "$FunctionName: first argument empty" \
		&& return 1;
	
	# Check if the file exists and run it
	local FilePath="${WD_InitPath}/${1}.sh"
	[[ -f "${FilePath}" ]] && source "${FilePath}" \
		|| echo "$FunctionName: ${FilePath} not found" && return 1;

}

# Run a tmux session or restore it
tmx() {
    [[ -n $1 ]] \
		&& (tmux attach -t $1 $2 &>/dev/null \
		|| tmux new-session -s $1 \; source-file $HOME/git/datafiles/config/tmux/sessions/$1.proj \; $2) \
	    || echo 'Usage: tmx setup-name <optional command>'

}

# Send the quit command to all panes/windows/sessions on tmux
tquit() {
		tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index}' \
				| xargs -I PANE tmux send-keys -t PANE 'C-c' 'C-d' Enter
}

##############
# OUTER CODE #
#  RUNNING   #
##############

# Add a scripts path to $PATH
[[ $PATH =~ (^|:)${WD_InitPath}/tools(/?)(:/$) ]] \
	|| PATH="$PATH:${WD_InitPath}/tools"

# Platform-based
if [[ $PLATFORM == "wsl" ]]; then
	import "platform/wsl"
	import "sets/tr"
elif [[ $PLATFORM == "termux" ]]; then
	import "platform/termux"
fi

# Any platform
import "sets/aliases"
import "sets/utilfuncs"

#############
# FINISHING #
#############

wdprompt # Run the code at the end of its definition

# Code ran on the first time.
if [[ $WD_FirstRun == 0 ]]; then

	# Set the FirstRun var to true
	WD_FirstRun=1

	# Run "tmx main", starting the main tmux session.
	[[ -z "$TMUX" ]] \
		&& tmx main

fi
