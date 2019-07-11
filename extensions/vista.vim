" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/liuchengxu/vista.vim')
    finish
endif

if extensions#isInstalled('vista.vim', 'vista.vim')
    let g:vista#renderer#enable_icon = 1
    let g:vista_executive_for = {
                \ 'javascript': 'coc',
                \ 'typescript': 'coc',
                \ 'javascript.jsx': 'coc',
                \ }
    let g:vista_close_on_jump = 1
    "" [N] <leader>r -- Toggle Symbols Sidebar [vista]
    nnoremap <silent> <leader>r :Vista!!<CR>
endif
