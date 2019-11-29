" Vim Test File
" Author: YohananDiamond
" Repository: https://github.com/YohananDiamond/dotfiles

""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:pathogen_disabled = []
if isdirectory('/sdcard')
    call add(g:pathogen_disabled, 'ultisnips')
endif
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
command! -nargs=+ RunFile call RunFile(<f-args>)

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
    au!
    au BufNewFile,BufRead,BufEnter *.py set filetype=python
    au! FileType python setlocal nosmartindent
    au! FileType python let b:runfile_command = "python3"
    au! FileType python setlocal cindent smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
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

func! RunFile(command, vsplit, ...)
    if exists("b:runfile_command")
        " Prepare the command string
        let l:command_string = 'terminal ' . a:command . ' % ' . join(a:000, ' ')
        " Split or VSplit & move to new window
        if (a:vsplit)
            vsplit
            normal l
        else
            split
            normal j
        endif
        " Execute the command
        execute l:command_string
        " Enter the terminal
        normal i
    else
        echo "Please define b:runfile_command with the command to run the current file (e.g. python3)."
    endif
endfunc

" TODO: Fix this (I have no idea on why it doesn't work, there are no errors)
" func! RunFileArgs(vsplit)
"     if exists("b:runfile_command")
"         let l:normal_string = 'normal :RunFile ' . b:runfile_command . ' '
"         execute l:normal_string
"     else
"         echo "Please define b:runfile_command with the command to run the current file (e.g. python3)."
"     endif
" endfunc

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
map <ScrollWheelUp> <C-U>
map <ScrollWheelDown> <C-D>

" Select all
nnoremap <silent> <Leader>a ggVG

" Copy to registers
nnoremap <silent> <Leader>y "+y
nnoremap <silent> <Leader>p "+p
nnoremap <silent> <Leader>d "+d
nnoremap <silent> <Leader>Y "+Y
nnoremap <silent> <Leader>P "+P
nnoremap <silent> <Leader>D "+D
vnoremap <silent> <Leader>y "+y
vnoremap <silent> <Leader>d "+d

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
nnoremap <silent> qç q:
nnoremap <silent> qÇ q:

" Open files, MRU and ALL on CtrlP with a slightly different mapping (see <Plugin Settings> section)
nnoremap <silent> <Leader>f :CtrlP<CR>
nnoremap <silent> <Leader>gf :CtrlPMixed<CR>
nmap <silent> <Leader>b <C-p>

" Folding Commands
nnoremap <silent> <Leader>o zA
nnoremap <silent> <Leader>m zm

" Escape terminal in nvim
tnoremap <silent> <C-w> <C-\><C-n><C-w>
tnoremap <silent> <M-w> <C-\><C-n>

" Use Tab to Complete or insert spaces
inoremap <silent> <Tab> <C-r>=TabOrComplete(1)<CR>
inoremap <silent> <S-Tab> <C-r>=TabOrComplete(0)<CR>

" Use <C-Space> on insert mode to expand snippets or jump through them
inoremap <silent> <C-Space> <C-r>=UltiSnips#ExpandSnippetOrJump()<CR>
inoremap <silent> <M-Space> <C-r>=UltiSnips#JumpBackwards()<CR>

" Navigate with <C-k>, <C-j> and <C-m> on Completion Mode
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "<C-k>"
inoremap <expr> <C-m> pumvisible() ? "\<C-y>" : "<C-m>"

" Filename completion with <C-l>
inoremap <silent> <C-l> <C-x><C-f>

" Run a file
nnoremap <silent> <Leader>r :exec "RunFile " . b:runfile_command . " 0"<CR>
nnoremap <silent> <Leader>vr :exec "RunFile " . b:runfile_command . " 1"<CR>
" nnoremap <silent> <Leader>cr :call RunFileArgs(0)<CR>
" nnoremap <silent> <Leader>cvr :call RunFileArgs(1)<CR>

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

" UltiSnips (map to some random unused key, since I'm using some other system to go to it, mentioned in the other mappings part. Laziness...
let g:UltiSnipsExpandTrigger='<C-4>'

" Load all packages (plugins)
packloadall
