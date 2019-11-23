#!/usr/bin/env sh

# I copied a lot of this from denysdovhan's install script :P
DOTFILES=${1:-"$HOME/git/dotfiles"}
DOTFILES_GITHUB_HTTPS="https://github.com/YohananDiamond/dotfiles"
DOTFILES_GITHUB_SSH="git@github.com:yohanandiamond/dotfiles"

# Colors
e='\033'
RESET="${e}[0m"
BOLD="${e}[1m"
CYAN="${e}[0;96m"
RED="${e}[0;91m"
YELLOW="${e}[0;93m"
GREEN="${e}[0;92m"

_exists() { command -v $1 > /dev/null 2>&1; }

# Success reporter
info() { echo -e "${CYAN}${*}${RESET}"; }

# Error reporter
error() { echo -e "${RED}${*}${RESET}"; }

# Success reporter
success() { echo -e "${GREEN}${*}${RESET}"; }

welcome() {

    # Celeste ASCII Art because why not
    echo "
▓  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▓▓▓▓▓▓▓▓▓▓▓  
▓▓▓▓▓▓▓▓████████████████████▓▓▓▓▓▓  ▓▓▓▓▓▓██████░░████▓▓▓▓▓▓
▓▓██████▒▒▒▒▒▒▒▒▒▒▓▓▒▒▒▒▒▒▓▓██▓▓▓▓▓▓▓▓▓▓██    ██░░    ██▓▓▓▓
██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██▓▓▓▓▓▓██  ░░  ██░░  ██▓▓▓▓▓▓
██▒▒▒▒▒▒▒▒▒▒▒▒▓▓▒▒▒▒▒▒▒▒▓▓▒▒▒▒██▓▓▓▓▓▓██    ░░    ░░██████▓▓
██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▒▒██▓▓▓▓▓▓██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██
▓▓██████▒▒▒▒▒▒▒▒▒▒▓▓░░░░░░░░████▓▓▓▓██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██
▓▓▓▓▓▓▓▓████▒▒▒▒▓▓░░░░░░░░░░████▓▓▓▓██░░▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒██
▓▓▓▓▓▓▓▓▓▓██▓▓▓▓▓▓▓▓░░░░░░██▓▓██▓▓▓▓██░░▒▒░░▒▒▒▒▒▒░░▒▒▒▒░░██
▓▓▓▓▓▓▓▓██▓▓▒▒▒▒▒▒▒▒▒▒▓▓▓▓████▓▓▓▓▓▓▓▓██▒▒▒▒▒▒▒▒▒▒░░░░▒▒██▓▓
▓▓▓▓▓▓▓▓██▒▒▒▒▒▒▒▒▒▒░░░░▒▒▒▒░░██▓▓▓▓▓▓▓▓██▒▒▒▒▒▒▒▒░░▒▒██▓▓▓▓
▓▓▓▓▓▓██▒▒▒▒▓▓▒▒▒▒░░░░▒▒▒▒░░██▓▓▓▓▓▓▓▓▓▓██▒▒▒▒▒▒▒▒██▓▓▓▓▓▓
▓▓▓▓▓▓▓▓██░░▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▓▓▓▓▓▓▓▓▓▓▓▓▓▓████████▓▓▓▓▓▓▓▓
▓▓▓▓▓▓██░░▒▒▒▒▓▓▓▓▒▒▒▒▒▒▒▒▓▓██▓▓▓▓▓▓▓▓  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
▓▓▓▓▓▓██░░░░██▓▓▒▒▒▒▓▓▓▓▓▓▒▒██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
▓▓▓▓▓▓▓▓████▓▓██▒▒▒▒▒▒██▒▒▒▒██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ▓▓
▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▒▒░░██▒▒░░██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████▓▓██████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
▓▓▓▓  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓"

    # The header and credits to the art
    echo "
                   YOHANAN'S DOTFILES!
      (Art found on https://textart.sh/topic/celeste)" # The newline is because I wanted to align it visually with the art. There probably is a better solution.

    # Create the DOTFILES var
    echo
    mkdir -p ~/.config/_vars
    echo $DOTFILES > ~/.config/_vars/DOTFILES
    info "The file ~/.config/_vars/DOTFILES was created, and it contains the path to the dotfiles, which is ${DOTFILES}"
    echo

    info "This script will guide you through installing git, vim, tmux and the dotfiles themselves."
    echo "Sorry if this is not polished :/"
    echo "If you find any problem, I'd be happy to get some issues on GitHub about it."
    echo
    read -p "Do you want to proceed with installation? [y/N] " -n 1 answer
    echo
    if [ ${answer} != "y" ]; then
        exit 1
    fi
}

install_programs() {
    echo
    info "Trying to install some programs..."
    for program in git tmux vim; do
        if ! _exists ${program}; then
            read -p "${program} is not installed; would you like to install it? [y/N] " -n 1 answer
            if [ ${answer} == "y" ]; then
                sudo apt install ${program}
            fi
        else
            success "${program} is installed; skipping..."
        fi
    done
}

install_dotfiles() {
    echo
    info "Trying to detect installed dotfiles in $DOTFILES..."

    if [ ! -d $DOTFILES ]; then
        echo "It seems like you don't have dotfiles installed!"
        read -p "Do you agree to proceed with dotfiles installation? [y/N] " -n 1 answer
        echo
        if [ ${answer} != "y" ]; then
            exit 1
        else
            read -p "Would you like to install it via HTTPS or SSH? [0/1] " -n 1 answer
            if [ ${answer} == 0 ]; then
                git clone --recursive ${DOTFILES_GITHUB_HTTPS} $DOTFILES
            else
                git clone --recursive ${DOTFILES_GITHUB_SSH} $DOTFILES
            fi
        fi
    else
        echo "Your dotfiles are already set up."
    fi

    echo
    info "Trying to sync the dotfiles and update symlinks..."
    cd $DOTFILES && ./sync.py && cd -
}

finish() {
  echo
  success "All done!"
  echo "The config files should be working now, at least I hope."
  echo "Remember to restart your terminal to assure everything will work properly."
  echo "You can also use the rbash command if you want just to reload the bash shell."
  echo
  sleep 1
}

main() {
    welcome $@
    install_programs $@
    install_dotfiles $@
    finish $@
}; main $@
