" Keymaps
" Author: YohananDiamond

func! keymaps#init()
    " Map the leader key to backslash
    let mapleader = '\'

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
    nnoremap <silent> ;a ggVG
    vnoremap <silent> ;a <Esc>ggVG

    " Copy to registers
    nnoremap <silent> <Space>y "+y
    nnoremap <silent> <Space>p "+p
    nnoremap <silent> <Space>x "+x
    vnoremap <silent> <Space>y "+y
    vnoremap <silent> <Space>p "+p
    vnoremap <silent> <Space>x "+x

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
    nnoremap <silent> <C-x>n :NERDTreeToggle<CR>

    " Close split
    nnoremap <silent> <C-x>0 :close<CR>
    inoremap <silent> <C-x>0 <C-o>:close<CR>
    vnoremap <silent> <C-x>0 <Esc>:close<CR>

    " Clear search query
    nnoremap <silent> <Leader>/ :noh<CR>

    " Kill buffers
    nnoremap <silent> <C-x>k :b#<bar>bd#<CR>

    " Actually delete instead of cutting
    nnoremap d "_d
    vnoremap d "_d

    " Use C-j on insert mode to go back to normal
    inoremap <C-j> <Esc>

    " Folding Commands
    nnoremap <silent> <space><right> zO
    nnoremap <silent> <space><left> zm
    nnoremap <silent> <space>l zO
    nnoremap <silent> <space>h zm
 
endfunc
