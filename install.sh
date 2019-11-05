#!/usr/bin/env bash
#mergetest

main() {
    local DOTFILES=$(realpath $(dirname $BASH_SOURCE))
    echo $DOTFILES
    rm -rv ~/.vim
    rm -rv ~/.config/Code/User/extensions.txt
    rm -rv ~/.config/Code/User/settings.json
    rm -rv ~/.config/Code/User/snippets
    rm -rv ~/.config/Code/User/keybindings.json
    rm -rv ~/.termux/termux.properties
    unlink ~/.bashrc
    unlink ~/.tmux.conf
    echo "source $DOTFILES/tmux.conf" > $HOME/.tmux.conf
    echo "source $DOTFILES/bashrc" > $HOME/.bashrc
    ln -s $DOTFILES/vim ~/.vim
    ln -s $DOTFILES/vscode/* -t ~/.config/Code/User/
    mkdir ~/.termux 2>/dev/null
    ln -s $DOTFILES/termux.properties ~/.termux/termux.properties
}; main
