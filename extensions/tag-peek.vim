" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/semanticart/tag-peek.vim')
    finish
endif

if extensions#isInstalled('tag-peek.vim', 'tag_peek.vim', 'autoload')
    nnoremap <silent> <C-o>  :call tag_peek#ShowTag()<CR>

        function! TagPeekFloat()
            " Make the floating window relative to the line it was called
            " One line below, at the same indent level
            " This is a little better than using relative:cursors because the
            " horizontal offset will always respect indentation
            let l:curpos = getcurpos() " returns [bufnum, line, col]
            let l:indentSize = strlen(getline('.')) - strlen(trim(getline('.'), ' '))
            return {
                        \ 'relative': 'editor',
                        \ 'row': l:curpos[1],
                        \ 'col': l:indentSize,
                        \ 'width': 80,
                        \ 'height': 20
                        \ }
        endfunction

    let g:tag_peek_float_config='TagPeekFloat'
endif


