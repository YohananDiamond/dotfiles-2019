" Plugins file.

" Import vim-plug for loading when it is not loaded
if !exists('g:plugs')
    " I'm using a weird trick where it checks if the g:plugs variable (defined by vim-plug) is set or not to decide wether it will load Plug again or not.
    Import 'contents/plug'
endif

if (g:Platform != 'windows')
    let s:plugstr = '~/.vim/plugged/'
else
    if exists('E:/files/scripts/vim')
        let s:plugstr = 'E:/files/scripts/vim-plugged/'
    else
        let s:plugstr = $HOME . '/yst/scripts/vim-plugged/'
    endif
endif

" Start plugin thing
call plug#begin(s:plugstr)

" Interface Plugins
Plug 'scrooloose/nerdtree'
Plug 'ap/vim-buftabline'
Plug 'itchyny/lightline.vim'

" File Modes
Plug 'neoclide/jsonc.vim'

" Snippets
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'

" Editor enchancement
Plug 'jiangmiao/auto-pairs'

" Finish plugin thing
call plug#end()

" Unused Plugins
" Plug 'joeytwiddle/sexy_scroller.vim'
" Plug 'jceb/vim-orgmode'
