" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/neoclide/vim-jsx-improve')
    call extensions#loadExtension('https://github.com/fleischie/vim-styled-components', { 'branch': 'main' })
    finish
endif


