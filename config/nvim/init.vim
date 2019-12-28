" Vim Test File
" Author: YohananDiamond
" Repository: https://github.com/YohananDiamond/dotfiles

""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:pathogen_disabled = []
if has("python3")
    call add(g:pathogen_disabled, "VimCompletesMe")
else
    call add(g:pathogen_disabled, "deoplete.nvim")
endif
let g:deoplete#enable_at_startup = 1
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
        let &guifont='Cascadia Code 10.5,Fira Code 10.5,Ubuntu Mono 12,Consolas 12,Monospace 12'
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
command! -nargs=+ RunFile call RunFile(eval(string(<q-args>))) " I don't even know at this point.

cnoreabbrev exs ExitSession

" Listchars
set listchars=tab:»\ 
set listchars+=space:·
set listchars+=extends:%
set listchars+=precedes:%
set listchars+=eol:$,
set listchars+=trail:~

filetype plugin indent on " Idk what is this but it seems to work.

" Enable RGB colors
set termguicolors

" Correct RGB escape codes for vim inside tmux
if !has('nvim') && $TERM ==# 'screen-256color'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" Set color theme
set background=dark
colorscheme onedark

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <Augroups> 

augroup tq
    au!
    au BufNewFile,BufRead,BufEnter *.tq set filetype=tq
    au FileType tq set syntax=tq
    au FileType tq setlocal foldmethod=indent
    au FileType tq call OptSpaceIndentation(2)
augroup end

augroup sh
    au! FileType sh call OptSpaceIndentation(4)
augroup end

augroup visualg
    au!
    au BufNewFile,BufRead,BufEnter *.alg set filetype=visualg
    au FileType visualg call OptSpaceIndentation(4)
    au FileType visualg set syntax=c " I don't have any syntax files for VisuAlg, so lets' use C syntax.
augroup end

augroup rust
    au!
    au FileType rust let b:runfile_command = "cargo run"
    au FileType rust set foldmethod=syntax
augroup end 

augroup julia
    au!
    au BufNewFile,BufRead,BufEnter *.jl set filetype=julia
    au FileType julia let b:runfile_command = "julia"
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
    execute '!xdg-open '.l:WORD.' &'
endfunc

func! TabOrComplete(mode)
    " Function called by the <Tab> (or <S-Tab>) key on insert mode.
    " Use <Tab> to complete when typing words, else inserts TABs as usual.
    " Pretty lightweight, I don't want to use an autocompletion engine for now. Maybe I'll start using when I learn Java or something like, idk.
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

func! RunFile(command, ...)
    let l:command_string = "terminal " . a:command . " % " . join(a:000, " ")
    split | normal j
    execute l:command_string
    normal i
endfunc

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <Function Calls?>

call OptSpaceIndentation(4) " Kinda unsafe, to be honest

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <Mapping>

" Map <Space> to <Leader> on a (kinda) better way
nmap <Space> <Leader>
vmap <Space> <Leader>

" Remove <Esc> delays
set timeoutlen=1000 ttimeoutlen=0

" Mouse Wheel Scrolling
map <ScrollWheelUp> 15<C-Y>
map <ScrollWheelDown> 15<C-E>

" Copy to X register (I guess)
" How this works: the other keybindings usually work; but, if they don't exist, this will instead send the "+ combination.
nnoremap <silent> <Leader> "+
vnoremap <silent> <Leader> "+

" Indentation Management
nnoremap <silent> <Tab> >>
nnoremap <silent> <S-Tab> <<
vnoremap <silent> <Tab> >gv
vnoremap <silent> <S-Tab> <gv

" Clear search query
nnoremap <silent> <Leader>/ :noh<CR>

" Use ç/Ç (from Portuguese/Brazilian keyboard) on normal mode for :
nmap Ç :
nmap ç :

" Open command-line mode
" nnoremap <silent> qç q:
" nnoremap <silent> qÇ q:

" Open files, MRU and ALL on CtrlP with a slightly different mapping (see <Plugin Settings> section)
nnoremap <silent> <Leader>f :CtrlP<CR>
nmap <silent> <Leader>b <C-p>

" Folding Commands
nnoremap <silent> <Leader>j zo
nnoremap <silent> <Leader>k zc
nnoremap <silent> <Leader>J zO
nnoremap <silent> <Leader>K zC
nnoremap <silent> <Leader>m zm

" Escape terminal in nvim
tnoremap <silent> <C-w>h <C-\><C-n>h
tnoremap <silent> <C-w>j <C-\><C-n>j
tnoremap <silent> <C-w>k <C-\><C-n>k
tnoremap <silent> <C-w>l <C-\><C-n>l
tnoremap <silent> <C-w> <C-\><C-n>

" Use Tab to Complete or insert spaces
inoremap <silent> <Tab> <C-r>=TabOrComplete(1)<CR>
inoremap <silent> <S-Tab> <C-r>=TabOrComplete(0)<CR>

" Navigate with <C-k>, <C-j> and <C-m> on Completion Mode
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "<C-k>"
inoremap <expr> <C-m> pumvisible() ? "\<C-y>" : "<C-m>"

" Run a file
nnoremap <silent> <Leader>r :exec ":RunFile " . b:runfile_command<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <Plugin Settings>

" Lightline
let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ 'active': {
      \   'left': [[ 'mode', 'paste' ], [ 'readonly', 'filename' ]],
      \ },
      \ }

" CtrlP
let g:ctrlp_cmd = 'CtrlPBuffer'

" vim-mucomplete Settings (test)
set completeopt-=preview
set completeopt+=menuone,noselect
set shortmess+=c   " Shut off completion messages
set belloff+=ctrlg " If Vim beeps during completion
let g:mucomplete#enable_auto_at_startup = 1

" Load all packages (plugins)
" packloadall
