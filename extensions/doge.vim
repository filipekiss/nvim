" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/kkoomen/vim-doge')
    finish
endif


let g:doge_comment_jump_modes = ['n', 's']
