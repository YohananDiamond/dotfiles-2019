" Vim Test File
" Author: YohananDiamond
" Repository: https://github.com/YohananDiamond/dotfiles

""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible
execute pathogen#infect()

" Initial Variables
let g:Config = {}
let g:Config.InitPath = resolve(expand('<sfile>:p:h'))

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
set complete=.,w,b,u,t " This actually was already the default, but I'm gonna force it because I don't know when it is default or not.
set completeopt=longest,menuone

" Commands
command! -nargs=0 WhitespaceMode set list!
command! -nargs=0 WrapMode set wrap!
command! -nargs=0 W w
command! -nargs=0 GitSync !echo "Syncing..." && git ac && git pp
command! -nargs=0 Black call BlackFormat()
command! -nargs=0 OpenWORD call OpenWORD()
command! -nargs=0 ExitSession execute 'mksession! | qa'

cnoreabbrev exs ExitSession

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <Augroups>

augroup todoq
    au!
    au BufNewFile,BufRead,BufEnter *.tq set filetype=todoq
    au FileType todoq call OptSpaceIndentation(4)
    au FileType todoq setlocal foldmethod=indent
augroup end

augroup sh
    au! FileType sh call OptSpaceIndentation(4)
augroup end

augroup python
    " Not gonna make the au! line here because I'm not sure if it will end up
    au! FileType python setlocal nosmartindent
augroup end

augroup visualg
    au!
    au BufNewFile,BufRead,BufEnter *.alg set filetype=visualg
    au FileType visualg call OptSpaceIndentation(4)
    au FileType visualg set syntax=c " I don't have any syntax files for VisuAlg, so lets' use C syntax.
augroup end

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <Functions>

" Create function to set tab indentation
func! OptTabIndentation(size)
	let &tabstop=a:size
	let &shiftwidth=a:size
	set noexpandtab
endfunc

" Create function to set space indentation
func! OptSpaceIndentation(size)
	let &tabstop=a:size
	let &shiftwidth=a:size
	set expandtab
	set softtabstop=0
	set smarttab
endfunc

" Black formatting
" I've made my own extension because I want something really, really simple.
func! BlackFormat()
    " Check if the buffer is modified
    if &modified
        echo "This buffer is modified! Please save your changes before running black."
    else
        !python3 -m black %
        edit " Reload the file
    endif
endfunc

func! OpenWORD()
    let l:WORD = expand("<cWORD>")
    execute '!xdg-open '.l:WORD
endfunc

func! TabOrComplete(mode)
    " Function called by the <Tab> (or <S-Tab>) key on insert mode.
    " Use <Tab> to complete when typing words, else inserts TABs as usual.
    " Pretty lightweight, I don't want to use an autocompletion engine for now. Maybe I'll start using when I learn java or something like, idk.
    " Stolen from https://github.com/luxpir/plaintext-productivity/blob/master/.vimrc
    " if col(".") > 1 && strpart(getline("."), col(".") - 2, 3) =~ '^\w'
    if (col(".") > 1) && strcharpart(getline("."), col(".") - 2, 1) =~ '\w'
        if (a:mode == 0)
            return "\<C-P>"
        elseif (a:mode == 1)
            return "\<C-N>"
        endif
    else
        return "\<Tab>"
    endif
endfunc

call OptSpaceIndentation(4)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <Mapping>

" Map <Space> to <Leader> on a (kinda) better way
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
nnoremap Ç :
nnoremap ç :

" Open command-line mode
nnoremap <silent> <Leader>ç q:
nnoremap <silent> <Leader>Ç q:
nnoremap <silent> <Leader>: q:

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

" Escape terminal in nvim
tnoremap <silent> <C-w> <C-\><C-n><C-w>

" Use Tab to Complete or insert spaces
inoremap <silent> <Tab> <C-r>=TabOrComplete(1)<CR>
inoremap <silent> <S-Tab> <C-r>=TabOrComplete(0)<CR>

" Navigate with <C-k>, <C-j> and <C-m> on Completion Mode
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "<C-k>"
inoremap <expr> <C-m> pumvisible() ? "\<C-y>" : "<C-m>"

" Filename completion with <C-l>
inoremap <silent> <C-l> <C-x><C-f>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <Plugin Settings>

" Lightline
let g:lightline = {
      \ 'colorscheme': 'deus',
      \ 'active': {
      \   'left': [[ 'mode', 'paste' ], [ 'readonly', 'filename' ]],
      \ },
      \ }

" CtrlP
let g:ctrlp_cmd = 'CtrlPBuffer'
