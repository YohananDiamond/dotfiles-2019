#!/usr/bin/env python3
# Dotfiles Synchronization
# Based off:
#  https://github.com/denysdovhan/dotfiles/blob/master/sync.py
#  https://github.com/sapegin/dotfiles/blob/master/sync.py

import os, sys, shutil, datetime, uuid
from pathlib import Path

# Make a lambda for creating expanded path objects
_path = lambda dest: Path(dest).expanduser()

# Options
_automatic_agree = False


def wrap(function, args=()):
    """Runs a function in a wrapped environment, cancelling some common error codes."""
    try:
        function(*args)
    except BaseException as e:
        error_type = type(e).__name__
        if error_type in {"KeyboardInterrupt", "EOFError"}:
            print(f"\n\033[35m(!)\033[m Operation Interrupted by {error_type}")
        else:
            raise e


def disclaimer(file_list, dirs_to_create, backup_dir):
    """Warns about what will be symlinked, deleted or backed up."""
    print("The following files will be created:")
    for file in file_list:
        print("  {}".format(file[2] / file[1]))
    print(
        f"If these files are on your computer already, their current versions will be backed up into the following folder (but broken symlinks will be deleted):\n  {backup_dir}."
    )
    print("The following directories will be created:")
    for dir_ in dirs_to_create:
        print(f"  {dir_}")
    return ask("Do you wish to continue with the operation?")


def ask(question):
    """Asks if the user will want to manually agree with each file."""
    i = input(f"\033[33m(?)\033[m {question} [Y/n] ").lower()
    return i != "n"


def main():

    # Create main variables
    DOTFILES = _path(__file__).absolute().parents[0]
    BACKUP_FOLDER = f"%Y%m%d-%H%M-{uuid.uuid4()}"
    BACKUP_DIR = _path(
        DOTFILES / ".backup" / (datetime.datetime.now().strftime(BACKUP_FOLDER))
    )

    # Prepare the files list
    files_list = []

    dest_home = _path("~")
    for home_file in (DOTFILES / "home").glob("*"):
        element = (home_file, home_file.name, dest_home)
        files_list.append(element)

    dest_vscode = _path("~/.config/Code/User")
    for vscode_file in (DOTFILES / "config/vscode").glob("*"):
        element = (vscode_file, vscode_file.name, dest_vscode)
        files_list.append(element)

    dest_nvim = _path("~/.config/nvim")
    for nvim_file in (DOTFILES / "config/nvim").glob("*"):
        element = (nvim_file, nvim_file.name, dest_nvim)
        files_list.append(element)

    # Window Manager Files
    dest_wman = _path("~/.config")
    for wman_file in ("bspwm", "i3", "polybar", "sxhkd", "compton.conf"):
        element = (DOTFILES / "config" / wman_file, wman_file, dest_wman)
        files_list.append(element)

    # Disclaimer and options
    if disclaimer(files_list, [dest_vscode, dest_nvim], BACKUP_DIR):
        print("You can press Ctrl-C or Ctrl-D at any time to cancel the operation.")
        _automatic_agree = not ask("Would you like to select which files to copy?")
        # Make necessary directories
        dest_vscode.mkdir(parents=True, exist_ok=True)
        dest_nvim.mkdir(parents=True, exist_ok=True)
        for file in files_list:
            symlink_file(*file, BACKUP_DIR, _automatic_agree)


def force_remove(path):
    """Forces the removal of a directory, symlink or file."""
    if path.is_dir() and (not path.is_symlink()):
        shutil.rmtree(path, False)
    else:
        path.unlink()


def is_link_to(link, dest):
    """Checks if :link is a link to :dest."""
    return (
        _path(link).is_symlink()
        and os.readlink(_path(link).absolute()) == _path(dest).absolute()
    )


def copy(path, dest):
    """Copies a directory or path."""
    if _path(path).is_dir():
        shutil.copytree(path, dest)
    else:
        shutil.copy(path, dest)


def symlink_file(
    file_path, file_name, dest_folder, backup_folder, automatic_agree=False
):
    """Makes a symlink called file_name in the folder dest_folder that points to file_path.

    file_path -- The complete file to symlink path.
    file_name -- The name (without parent folders) that the symlink file will point to.
    dest_folder -- The folder where the symlink file will be created.
    """
    symlink_dest = dest_folder / file_name
    print(f"\033[32m(*)\033[m Symlinking {symlink_dest}...")

    if (symlink_dest.exists()
        or symlink_dest.is_symlink()):
        # Yeah. This is a weird hack for detecting broken symlinks.

        # Ask if the user wants to overwrite the file.
        if not automatic_agree:
            if not ask(f"Backup and overwrite file {symlink_dest}?"):
                return

        if symlink_dest.exists(): # Prevent broken symlinks
            backup_path = (
                backup_folder / str(symlink_dest)[1:]
            ) # Weird hack to remove the first slash from '/home' or any other and make it possible to create a folder inside the backup folder with that name
            backup_folder.mkdir(exist_ok=True, parents=True)
            backup_path.parents[0].mkdir(exist_ok=True, parents=True)
            copy(symlink_dest, backup_path)

            print(f"\033[36m(B)\033[m Made a backup to {backup_path}")

        force_remove(symlink_dest)

    symlink_dest.symlink_to(file_path)
    print(f"\033[34m(L)\033[m {symlink_dest} \033[34m:=\033[m {file_path}")


if __name__ == "__main__":
    wrap(main, ())
