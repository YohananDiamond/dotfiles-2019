#!/usr/bin/env bash

#############
# CONSTANTS #
#############
WD_GitRepos="$HOME/git"

#############
# ENV. VARS #
#############

# Connect to the X Server (VcXsrv)
export DISPLAY=localhost:0.0

#############
# FUNCTIONS #
#############

# Windows drive mount/umount into /mnt/
wdmnt() {
	if [[ $1 == "-m" ]]; then
		[[ $2 == "" ]] \
			&& echo "wdmnt -m: unnamed mount drive" \
			|| sudo mount -t drvfs "$2"':' "/mnt/$2"
	elif [[ $1 == "-u" ]]; then
		[[ -z $2 ]] \
			&& echo "wdmnt -u: unnamed mount drive" \
			|| sudo umount "/mnt/$2"
	else
		echo "Usage: wdmnt \'-m | -mu\' drivename"
	fi
}

##############
# OTHER CMDS #
##############

# Copy the function "command_not_found_handle" from WSL's Ubuntu to commandSearch. It, for some reason, takes too much time, so I've decided to disable it when on WSL.
# This command (copy-function) is under the "tools" directory.
copy-function 'command_not_found_handle' 'commandSearch'

# Create a simple substitute for "command-not_found_handle"
command_not_found_handle() {
	printf "%s: command not found\n" "$1" 1>&2;
	return 127;
}
