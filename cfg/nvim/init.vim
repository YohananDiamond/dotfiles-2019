" Vim Test File
" Author: YohananDiamond
" Repository: https://github.com/YohananDiamond/dotfiles

""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible
execute pathogen#infect()

" Initial Variables
let g:Config = {}
let g:Config.InitPath = resolve(expand('<sfile>:p:h'))

" Set up import and reload commands
command! -nargs=1 Import
    \ if isdirectory('C:\') | let s:extra = '/vimfiles' | else | let s:extra = '' | endif |
	\ exec 'source ' . g:Config.InitPath . s:extra . "/" . eval(<f-args>) . '.vim'
command! -nargs=0 Reload
	\ source $MYVIMRC

" GUI or not
if has('gui_running')
    set guioptions=agit

    if isdirectory('C:\')
        let &guifont='Fixedsys 9,Ubuntu Mono 12,Fira Code 10.5,Cascadia Code 10.5,Consolas 12,Monospace 12'
    else
        let &guifont='Ubuntu Mono 12,Fira Code 10.5,Cascadia Code 10.5,Consolas 12,Monospace 12'
    endif
endif

" Set status line settings (when not using lightline)
if isdirectory('C:\')
    set statusline=\ %f
    set statusline+=%=
    set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
    set statusline+=\ [%{&fileformat}\]\ 
    set statusline+=\ %p%%\ 
    set statusline+=\ %l:%c
    set statusline+=\ 
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <Editor settings & etc.>

syntax on
set backspace=indent,eol,start
set laststatus=2 " Enable status bar
set number relativenumber " Hybrid numbers on the left edge of the screen
set encoding=utf-8
set textwidth=0 wrapmargin=0 " Prevent physical linebreak
set wildmode=longest,list " Bash-like command completion
set hidden " Prevent quitting vim with :q & etc.
set autoindent " For keeping the same indentation level on new lines
set hlsearch incsearch " Highlight & increment
set virtualedit=
set display+=lastline
set linebreak
set wrap
set cursorline
set mouse=a " Enable mouse
set showcmd

" Commands
command! -nargs=0 WhitespaceMode set list!
command! -nargs=0 WrapMode set wrap!
command! -nargs=0 W w
command! -nargs=0 GitSync !echo "Syncing..." && git ac && git pp

" Listchars
set listchars=tab:»\ 
set listchars+=space:·
set listchars+=extends:%
set listchars+=precedes:%
set listchars+=eol:$,
set listchars+=trail:~

filetype plugin indent on " Idk what is this but it seems to work.

" Set color theme
set background=dark
colorscheme monokai

" Autocmds
autocmd BufNewFile,BufRead,BufEnter *.tq :set filetype=todoq
autocmd FileType todoq :call OptSpaceIndentation(4)
autocmd FileType todoq :set foldmethod=indent
autocmd FileType python setlocal nosmartindent

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <Option Functions>

" Create function to set tab indentation
func! OptTabIndentation(size)
	let &tabstop=a:size
	let &shiftwidth=a:size
	set noexpandtab
endfunction

" Create function to set space indentation
func! OptSpaceIndentation(size)
	let &tabstop=a:size
	let &shiftwidth=a:size
	set expandtab
	set softtabstop=0
	set smarttab
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <Functions>

func! XReplace(...)
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
command! -nargs=0 XReplace call XReplace()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <Mapping>

" Map <Space> to <Leader> on a (kinda) better way
" 
nmap <Space> <Leader>
vmap <Space> <Leader>

" Remove <Esc> delays
set timeoutlen=1000 ttimeoutlen=0

" Switch between buffers
nnoremap <silent> <C-x>j :bn<CR>
nnoremap <silent> <C-x>k :bp<CR>
tnoremap <silent> <C-x>j <C-w>:bn<CR>
tnoremap <silent> <C-x>k <C-w>:bp<CR>
nnoremap <silent> <C-x><Down> :bn<CR>
nnoremap <silent> <C-x><Up> :bp<CR>
tnoremap <silent> <C-x><Down> <C-w>:bn<CR>
tnoremap <silent> <C-x><Up> <C-w>:bp<CR>

" Mouse Wheel Scrolling
map <ScrollWheelUp> <C-U>
map <ScrollWheelDown> <C-D>

" Select all
nnoremap <silent> <Leader>a ggVG
vnoremap <silent> <Leader>a <Esc>ggVG

" Copy to registers
nnoremap <silent> <Leader>y "+y
nnoremap <silent> <Leader>p "+p
nnoremap <silent> <Leader>x "+x
nnoremap <silent> <Leader>d "+d
vnoremap <silent> <Leader>y "+y
vnoremap <silent> <Leader>p "+p
vnoremap <silent> <Leader>x "+x
vnoremap <silent> <Leader>d "+d

" Indentation Management
nnoremap <silent> <Tab> >>
nnoremap <silent> <S-Tab> <<
vnoremap <silent> <Tab> >gv
vnoremap <silent> <S-Tab> <gv
inoremap <silent> <S-Tab> <C-o>:exec 'normal '.&tabstop.'X'<CR>

" Toggle NERDTree
nnoremap <silent> <C-C>o :NERDTreeToggle<CR>

" Close windows
nnoremap <silent> <C-x>0 :close<CR>

" Clear search query
nnoremap <silent> <Leader>/ :noh<CR>

" Use ç/Ç (from Portuguese/Brazilian keyboard) on normal mode for :
nmap Ç :
nmap ç ;

" Some complex commands; I'm still testing them.
nnoremap <silent> <Leader>d*t ggdG

" Open files, MRU and ALL on CtrlP with a slightly different mapping (see <Plugin Settings> section)
nnoremap <silent> <C-o> :CtrlP<CR>
nnoremap <silent> <C-c>0 :CtrlPMRU<CR>
nnoremap <silent> <C-c>p :CtrlPMixed<CR>

" Folding Commands
nnoremap <silent> <Leader>o zA
nnoremap <silent> <Leader>m zm

" Add a new task (todoq format) to the end of the line.
" Yeah. I need to move this into a plugin. I'll do it later.
nnoremap <silent> <Leader>dn Go<C-o>0- [ ] <C-r>=strftime('%F')<CR> 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <Plugin Settings>

" Lightline
let g:lightline = {
      \ 'colorscheme': 'deus',
      \ 'active': {
      \   'left': [[ 'mode', 'paste' ], [ 'readonly', 'filename' ]],
      \ },
      \ }

" Space Indentation
call OptSpaceIndentation(4)

" CtrlP
let g:ctrlp_cmd = 'CtrlPBuffer'