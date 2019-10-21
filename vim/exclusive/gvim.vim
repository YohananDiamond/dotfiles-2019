" gVim Options

" Set GuiOptions
set guioptions=agit

" Set GuiFont
if (g:Platform != 'windows')
	let &guifont='Cascadia Code 10.5,Consolas 12,Monospace 12'
else
	let &guifont='Cascadia Code:h10.5,Consolas:h12,monospace:h12'
endif
