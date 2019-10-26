" Interactive Functions
" Author: YohananDiamond

func! itr#replace(...)
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

