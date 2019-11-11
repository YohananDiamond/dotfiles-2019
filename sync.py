#!/usr/bin/env python3

"""Dotfiles syncronization.
Recursively based on: https://github.com/denysdovhan/dotfiles/blob/master/sync.py
Based on: https://github.com/sapegin/dotfiles/blob/master/sync.py
"""

import os, sys, shutil, datetime
from pathlib import Path

# Make a lambda for creating expanded path objects
_path = lambda dest: Path(dest).expanduser()

def force_remove(path):
    """Forces the removal of a directory, symlink or file."""
    if path.is_dir() and (not path.is_symlink()):
        shutil.rmtree(path, False)
    else:
        path.unlink()

def is_link_to(link, dest):
    """Checks if :link is a link to :dest."""
    return _path(link).is_symlink() and os.readlink(_path(link).absolute()) == _path(dest).absolute()

def copy(path, dest):
    """Copies a directory or path."""
    if _path(path).is_dir():
        shutil.copytree(path, dest)
    else:
        shutil.copy(path, dest)

def symlink_file(file, source_dir, dest_dir, backup_dir, options_dict={}):

    print(f'Symlinking {file}...')

    source_file = source_dir / file # The file that exists in the dotfiles repository and will be pointed to by the symlink files.
    dest_file = dest_dir / file # The file that will be created and will point to the source_file.

    # Get options from the dict
    backup_conflicts = options_dict['backup_conflicts'] if 'backup_conflicts' in options_dict else False
    
    # Check if we aren't overwriting anything
    if dest_file.exists():

        # Ignore file if it already is the link that we want.
        if is_link_to(dest_file, source_file): return

        # Set up input variable
        input_ = ''

        # Ask for overwriting file.
        input_ = 'y' if backup_conflicts else input(f'Overwrite file {dest_file}? [y/N] ').lower()

        if input_ == '@':
            backup_conflicts = options_dict['backup_conflicts'] = True
        elif not input_ == 'y':
            print(f'Skipping {dest_file}...')
            return

        else:

            # Make backup copy if we're overwriting this file
            input_ = 'y' if backup_conflicts else input(f'Make a backup of {dest_file}? [y/N] ').lower()
            if input_ == 'y':
                backup_dir.mkdir(exist_ok=True, parents=True)
                backup = backup_dir / dest_file.name
                copy(dest_file, backup)
                print(f'Made a backup to {backup}')
            elif input_ == '@':
                backup_conflicts = options_dict['backup_conflicts'] = True

        # Remove the dest_file after doing the process above
        force_remove(dest_file)

    dest_file.symlink_to(source_file)
    print(f'{source_file} \033[34m=>\033[m {dest_file}')

def symlink_all_files(source_dir, dest_dir, backup_dir):

    # Initial warning (?)
    print('Type @ in any of the prompts to ignore conflicts and delete with backup.')

    # Initial Options
    options = {
        'backup_conflicts': False # When True, ignores prompts and always replaces, but backing up first.
    }

    # Make the files list to analysis
    files = [file.name for file in source_dir.glob('*')]

    # Iterate throught the files list
    for file in files:
        symlink_file(file, source_dir, dest_dir, backup_dir, options_dict=options) 

    # VSCode Files
    vscode_files = [file.name for file in (_path(source_dir) / '..' / 'vscode').glob('*')]

    # Iterate through the vscode files list
    for file in vscode_files:
        _path('~/.config/Code/User').mkdir(parents=True, exist_ok=True)
        symlink_file(file, _path(source_dir) / '..' / 'vscode', _path('~/.config/Code/User'), backup_dir, options_dict=options)

def main():

    # Process arguments from command line
    # args = (source, destination, backup)
    args = tuple(sys.argv[1:]) if len(sys.argv) > 1 else ()

    # Create main variables
    DOTFILES = _path(__file__).absolute().parents[0]
    SOURCE_DIR = _path(args[0] if len(args) >= 1 else (DOTFILES / 'home'))
    DEST_DIR = _path(args[1] if len(args) >= 2 else '~')
    BACKUP_DIR = _path(args[2] if len(args) >= 3 else (DOTFILES / '.backup' / (datetime.datetime.now().strftime('%Y%m%d-%H:%M'))))

    # Symlink all files
    symlink_all_files(SOURCE_DIR, DEST_DIR, BACKUP_DIR)

if __name__ == '__main__':
    try: main()
    except KeyboardInterrupt: print('\nOperation Interrupted by KeyboardInterrupt.')
