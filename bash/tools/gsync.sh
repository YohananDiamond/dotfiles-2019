#!/usr/bin/env bash
# GSync : Git Sync
# A little script that runs some syncing tools using git.
# It is not very reccomended

# Before everything, check if some needed variables are set or not.
# [[ -z "$" ]] && echo 'gsync: $ not set. Please set it.' && return 1;
# [[ -z "$" ]] && echo 'gsync: $ not set. Please set it.' && return 1;
# (TODO) Add some system to store settings in a file, including key-values to repo files

# Time and color variables
GSYNC_Time=$(date +"%F %H:%M");
GSYNC_Color="\e[1;35m";

# Colored print function
GSYNC_Print() {
    printf "${GSYNC_Color}%s\e[m\n" "$@";
}
