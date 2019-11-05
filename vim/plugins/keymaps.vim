" Keymaps
" Author: YohananDiamond

func! keymaps#init()
    " Map the leader key to backslash
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
    nnoremap <silent> <C-x>l :bn<CR>
    nnoremap <silent> <C-x>h :bp<CR>
    inoremap <silent> <C-x>l <C-o>:bn<CR>
    inoremap <silent> <C-x>h <C-o>:bp<CR>
    tnoremap <silent> <C-x>l <C-w>:bn<CR>
    tnoremap <silent> <C-x>h <C-w>:bp<CR>
    vnoremap <silent> <C-x>l <Esc>:bn<CR>
    vnoremap <silent> <C-x>h <Esc>:bp<CR>

    " Switch between tabs
    nnoremap <silent> <C-x>o :tabn<CR>
    nnoremap <silent> <C-x>k :tabp<CR>
    inoremap <silent> <C-x>o <C-o>:tabn<CR>
    inoremap <silent> <C-x>k <C-o>:tabp<CR>
    tnoremap <silent> <C-x>o <C-w>:tabn<CR>
    tnoremap <silent> <C-x>k <C-w>:tabp<CR>
    vnoremap <silent> <C-x>o <Esc>:tabn<CR>
    vnoremap <silent> <C-x>k <Esc>:tabp<CR>

    " Go to start/end of a document or line
    nnoremap <silent> K :0<CR>
    nnoremap <silent> J :$<CR>
    nnoremap <silent> L g<End>
    nnoremap <silent> H g<Home>

    " Mouse Wheel Scrolling
    map <ScrollWheelUp> <C-U>
    map <ScrollWheelDown> <C-D>

    " Select all
    nnoremap <silent> <space>a ggVG
    vnoremap <silent> <space>a <Esc>ggVG

    " Copy to registers
    nnoremap <silent> <space>y "+y
    nnoremap <silent> <space>p "+p
    nnoremap <silent> <space>x "+x
    vnoremap <silent> <space>y "+y
    vnoremap <silent> <space>p "+p
    vnoremap <silent> <space>x "+x

    " Move by graphical, not physical line
    nnoremap <silent> <Up> gk
    nnoremap <silent> <Down> gj
    vnoremap <silent> <Up> gk
    vnoremap <silent> <Down> gj
    nnoremap <silent> <End> g<End>
    nnoremap <silent> <Home> g<Home>
    vnoremap <silent> <End> g<End>
    vnoremap <silent> <Home> g<Home>

    " Indentation Management
    nnoremap <silent> <Tab> >>
    nnoremap <silent> <S-Tab> <<
    vnoremap <silent> <Tab> >gv
    vnoremap <silent> <S-Tab> <gv

    " Plugin-related
    nnoremap <silent> <space>xn :NERDTreeToggle<CR>

    " Close split
    nnoremap <silent> <space>x0 :close<CR>

    " Clear search query
    nnoremap <silent> <space>/ :noh<CR>

    " Kill buffers
    nnoremap <silent> <space>xk :b#<bar>bd#<CR>

    " Use C-j on insert mode to go back to normal
    inoremap <C-j> <Esc>

    " Folding Commands
    nnoremap <silent> <space><right> zO
    nnoremap <silent> <space><left> zm
    nnoremap <silent> <space>l zO
    nnoremap <silent> <space>h zm

    " Use ç/Ç on normal mode as comma
    nmap Ç :
    nmap ç ;
 
endfunc
