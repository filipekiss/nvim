" Explicitily set $VIMHOME
let $VIMHOME=expand('~/.vim')

" Add $VIMHOME/after to runtimepath
" :h 'runtimepath'
let &runtimepath .= ','.$VIMHOME.','.$VIMHOME.'/after'.','.$VIMHOME.'/doc'

" If the file setup.vim exists in $VIMHOME/autoload/setup.vim,
" call the setup#init() function
if !empty(glob($VIMHOME.'/autoload/setup.vim'))
    call setup#init()
endif
