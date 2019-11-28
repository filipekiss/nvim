" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/norcalli/nvim-colorizer.lua')
    finish
endif

" See $VIMHOME/lua/init.lua
