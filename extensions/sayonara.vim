" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/filipekiss/vim-sayonara')
    finish
endif

let g:sayonara_startify = 1
let g:sayonara_confirm_quit = 1

"" [N] <Leader>q -- Close current buffer [sayonara]
nnoremap <expr><silent> <leader>q &diff ? ":windo bd<CR>" : ":Sayonara<CR>"

