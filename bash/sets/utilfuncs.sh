#!/usr/bin/env bash

# History Grep
hgrep() { history | grep $@ | bat; }

# File/Directory Info
# di = "Directory Info", even though it also works with files.
# It's mostly because it shows info of the directory if noargs.
di() { du -shc "$@" | sort -rh; }
