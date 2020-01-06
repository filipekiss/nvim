" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/wellle/context.vim')
    finish
endif

let g:context_enabled = 0

"" [N] <leader>cx -- Toggle Context [context]
nnoremap <leader>cx :silent ContextToggle<CR>


