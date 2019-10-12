#!/usr/bin/env bash
# Bash Dotfiles
# Author: YohananDiamond
# 
# Note: most custom commands are under the "wd" command
# and most options are under the "wdx" command.

#############
# CONSTANTS #
#############

# The directory of this path
WD_InitPath=$(dirname $BASH_SOURCE)

# Current Platform
# (TODO) Improve this. It looks kinda flawled and hard to use.
[[ -r "/sdcard" ]] && WD_Platform="termux" || \
	[[ -r "/mnt/c/Windows" ]] && WD_Platform="wsl" || \
	WD_Platform="regular"

#############
# INIT VARS #
#############

# Bash "first run in session" code
[[ -z "$WD_FirstRun" ]] && WD_FirstRun=0

#############
# FUNCTIONS #
#############

# wdrun: run .sh files inside this directory.
wdrun() {

	# Function name for error prompting
	local FunctionName="wdrun"

	# Verify if the input is okay
	[[ "$1" == "" ]] && echo "$FunctionName: first argument empty" && \
		return 1;
	
	# Check if the file exists and run it
	local FilePath="${WD_InitPath}/${1}.sh"
	[[ -f "${FilePath}" ]] && source "${FilePath}" || \
		echo "$FunctionName: ${FilePath} not found" && return 1;

}
