" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/junegunn/goyo.vim')
    finish
endif

"" [N] <leader>g -- Toggle Goyo [goyo.vim]
nmap <silent> <leader>g :Goyo<CR>

augroup GoyoLimelight
    autocmd! User GoyoEnter let b:fckNoLineNumbers = 1
    autocmd! User GoyoLeave let b:fckNoLineNumbers = 0
augroup END

let g:goyo_width=85
