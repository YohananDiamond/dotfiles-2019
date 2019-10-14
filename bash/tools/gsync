#!/usr/bin/env bash
# GSync : Git Sync
# A little script that runs some syncing tools using git.
# It is not very recommended for regular repositories. I only use this for personal repositories, when I'm too lazy to run all commands.

# Load config
# Inside the config file, put a command exporting a list with the repositories' paths.
# e.g.: export GSYNC_List=(dir1 dir2)
source ~/git/dotback/config.sh

# Time and color variables
GSYNC_Time=$(date +"%F %H:%M");
GSYNC_Color="\e[1;35m";

# Custom-colored print function for GSync
GSYNC_fPrint() { printf "${GSYNC_Color}%s\e[m\n" "$@"; }

# Main syncing code
GSYNC_fSyncCurrent() {

	printf "\e[1;35m@GSYNC\e[m : ${PWD}\n"

	GSYNC_fPrint "01) FETCH"
	git fetch

	GSYNC_fPrint "02) LOG (Last 5)"
	git log --oneline -5

	GSYNC_fPrint "03) STATUS"
	git add .
	git status --short

	GSYNC_fPrint "04) PULL"
	git pull

	GSYNC_fPrint "05) COMMIT"
	git commit -m "Sync (${GSYNC_Time})"

	GSYNC_fPrint "06) PUSH"
	git push

	# Assure Merge Section
	# This part assures that the conflicts are merged without needing to run the command again.

	GSYNC_fPrint "07) STATUS II"
	git add .
	git status --short

	GSYNC_fPrint "08) PULL"
	git pull

	GSYNC_fPrint "09) COMMIT"
	git commit -m "Sync (${GSYNC_Time})"

	GSYNC_fPrint "10) PUSH"
	git push

}

set +x

# Sync a repo by its path
if ([[ $1 == "dir" ]] || [[ $1 == "d" ]]); then
	cd $2
	GSYNC_fSyncCurrent

# Sync all repos from the list
elif ([[ $1 == "all" ]] || [[ $1 == "a" ]]); then
	# To set this: 
	for foo in ${GSYNC_List[@]}; do
		cd $foo
		GSYNC_fSyncCurrent
	done

# Show help if the arguments are invalid.
else
	echo 'usage: gsync (option) ($2)'
	echo 'option: dir | d = specified dir ($2)'
	echo 'option: all | a = all from list $GSYNC_List'

fi
