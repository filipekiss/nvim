" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/junegunn/vim-easy-align')
    finish
endif

" Start interactive EasyAlign in visual mode (e.g. vipga)
"" [X] ga -- Easy Align Interactive Mode [easy-align]
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
"" [N] ga -- Easy Align (accepts motion) [easy-align]
nmap ga <Plug>(EasyAlign)
