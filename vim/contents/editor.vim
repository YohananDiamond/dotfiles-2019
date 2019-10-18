" Editor Settings
" Author: YohananDiamond

" Remove Vi-Compatible mode
set nocompatible

" Set backspace to something actually useful
set backspace=indent,eol,start

" Enable syntax highlighting
syntax on

" Always enable the status bar
set laststatus=2

" Enable line numbers on the left
set number

" Force encoding to utf-8 (on gVim-Windows it is set by default to latin1, and I don't want that)
set encoding=utf-8

" Prevent the editor from physically breaking lines.
set textwidth=0 wrapmargin=0

" Set the listchars for whitespace mode.
set listchars=tab:»\ 
set listchars+=space:·
set listchars+=extends:%
set listchars+=precedes:%
set listchars+=eol:$,
set listchars+=trail:~

" Enable command completion (wildmenu)
set wildmode=longest,list 

" Refuse quitting when there is an unsaved buffer, even if hidden.
set hidden

" Enable autoindent
set autoindent

" Search options
set hlsearch " Search Higlighting
set incsearch " Incrementing Search

" Cursor-related settings
set virtualedit=
set display+=lastline
set linebreak

" Create command to toggle whitespace mode
command! -nargs=0 WhitespaceMode set list!

" Create command to toggle wrap
command! -nargs=0 WrapMode set wrap!
set wrap

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

" Replace some exit commands
"cnorea <silent> q bd   
"cnorea <silent> q! bd!
"cnorea <silent> wq w<bar>bd
cnorea <silent> bk b#<bar>bd#
cnorea <silent> bc close

" Open netrw
cnorea <silent> nw e .

" Set status line settings (when not using lightline)
if (g:Platform == 'windows')
    set statusline=\ %f
    set statusline+=%=
    set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
    set statusline+=\ [%{&fileformat}\]\ 
    set statusline+=\ %p%%\ 
    set statusline+=\ %l:%c
    set statusline+=\ 
endif
