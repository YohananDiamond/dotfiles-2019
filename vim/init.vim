" Vim Init File
" Author: YohananDiamond

" Constants
let g:InitPath = resolve(expand('<sfile>:p:h'))

" Set up Import and Reload commands
command! -nargs=1 Import
	\ exec 'source ' . g:InitPath . "/" . eval(<f-args>) . '.vim'
command! -nargs=0 Reload
	\ source $MYVIMRC

" WSL
if isdirectory('/mnt/c/Windows')
	let g:Platform = 'wsl'
	Import 'exclusive/wsl'

" Termux
elseif isdirectory('/sdcard')
	let g:Platform = 'termux'
	Import 'exclusive/termux'

" Linux (not of above)
elseif isdirectory('/usr')
	let g:Platform = 'linux'
	Import 'exclusive/linux'

" Windows
elseif isdirectory('C:\')
	let g:Platform = 'windows'

endif

" Import some scripts
Import 'contents/keymaps'
Import 'contents/editor'

" gVim (general)
if has('gui_running')
	Import 'exclusive/gvim'
	
" Terminal Vim (general)
else
	Import 'exclusive/term'

endif

" Run Plugins
if (g:Platform != 'windows')
	Import 'plugins'
else
	Import 'plugins'
endif

" Import the theme API (not used anymore)
"Import 'themes/themeAssist'

" Load the theme
" For some weird reason, vim on my WSL instance was glitching if only loading the edge theme directly, so I have added the load of another theme before. This somehow works and I have no idea why.
Import 'themes/plastic'
Import 'themes/edge'

" Load custom settings
Import 'settings'

" Bruh
func! InteractiveReplace(...)
    let l:a = input('Replace> ')
    let l:b = input('Replace /' . l:a . '/ with> ')
    let l:c = input('One by one? [Y/n] ')
    if (l:c == 'Y') || (l:c == 'y')
        let l:mode = 'gc'
    elseif (l:c == 'N') || (l:c == 'n')
        let l:mode = 'g'
    else
        let l:mode = 'g'
    endif
    exec '%s/' . l:a . '/' . l:b . '/' . l:mode
endfunc

" TODO Make a better buffer delete thing and put it on a plugin
" TODO make a better mapping system that uses \ for Leader (plugins) and ;,<Space> for my custom mappings -- and use functions for that
" TODO Make my functions for ({[<Backspace><Tab> etc.

set mouse=a
