" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/junegunn/limelight.vim')
    finish
endif

if extensions#isInstalled('goyo.vim', 'goyo.vim')
    augroup GoyoLimelight
        autocmd! User GoyoEnter Limelight
        autocmd! User GoyoLeave Limelight!
    augroup END
endif
"
" Color name (:help cterm-colors) or ANSI code
let g:limelight_conceal_ctermfg = 'gray'

" Color name (:help gui-colors) or RGB color
let g:limelight_conceal_guifg = 'DarkGray'
