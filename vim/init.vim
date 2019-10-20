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
