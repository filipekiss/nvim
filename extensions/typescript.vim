" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/leafgarland/typescript-vim')
    call extensions#loadExtension('https://github.com/peitalin/vim-jsx-typescript')
    finish
endif


