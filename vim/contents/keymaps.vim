" Keymaps

" Map the leader key to space
let mapleader = ' '

" Switch between buffers
nnoremap <silent> <C-x><right> :bn<CR>
nnoremap <silent> <C-x><left> :bp<CR>
inoremap <silent> <C-x><right> <C-o>:bn<CR>
inoremap <silent> <C-x><left> <C-o>:bp<CR>
tnoremap <silent> <C-x><right> <C-w>:bn<CR>
tnoremap <silent> <C-x><left> <C-w>:bp<CR>
vnoremap <silent> <C-x><right> <Esc>:bn<CR>
vnoremap <silent> <C-x><left> <Esc>:bp<CR>

" Switch between tabs
nnoremap <silent> <C-x>o :tabn<CR>
nnoremap <silent> <C-x>k :tabp<CR>
inoremap <silent> <C-x>o <C-o>:tabn<CR>
inoremap <silent> <C-x>k <C-o>:tabp<CR>
tnoremap <silent> <C-x>o <C-w>:tabn<CR>
tnoremap <silent> <C-x>k <C-w>:tabp<CR>
vnoremap <silent> <C-x>o <Esc>:tabn<CR>
vnoremap <silent> <C-x>k <Esc>:tabp<CR>

" Go to start/end of a document
nnoremap <silent> <C-Home> :0<CR>
nnoremap <silent> <C-End> :$<CR>

" Select all
nnoremap <silent> <Leader>a ggVG
vnoremap <silent> <Leader>a <Esc>ggVG

" Copy to registers
nnoremap <silent> <Leader>y "+y
nnoremap <silent> <Leader>p "+p
nnoremap <silent> <Leader>x "+x
vnoremap <silent> <Leader>y "+y
vnoremap <silent> <Leader>p "+p
vnoremap <silent> <Leader>x "+x

" Move by graphic, not physical line
nnoremap <silent> <Up> gk
nnoremap <silent> <Down> gj
vnoremap <silent> <Up> gk
vnoremap <silent> <Down> gj
nnoremap <silent> <End> g<End>
nnoremap <silent> <Home> g<Home>
vnoremap <silent> <End> g<End>
vnoremap <silent> <Home> g<Home>

" Insert space
nnoremap <silent> <Leader><Space> <Space>

" Indentation Management
nnoremap <silent> <Tab> >>
nnoremap <silent> <S-Tab> <<
vnoremap <silent> <Tab> >gv
vnoremap <silent> <S-Tab> <gv

" Plugin-related
nnoremap <silent> <C-x>n :NERDTreeToggle<CR>

" Close split
nnoremap <silent> <C-x>0 :close<CR>
inoremap <silent> <C-x>0 <C-o>:close<CR>
vnoremap <silent> <C-x>0 <Esc>:close<CR>

" Clear search query
nnoremap <silent> <Leader>/ :noh<CR>

" Actually delete instead of cutting
nnoremap d "_d
vnoremap d "_d
