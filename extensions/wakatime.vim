" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/wakatime/vim-wakatime')
    finish
endif

if extensions#isMissing('vim-wakatime', 'wakatime.vim')
    finish
endif


