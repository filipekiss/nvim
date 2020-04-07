command! -nargs=0 -bar OrganizeImport :call CocAction('runCommand', 'tsserver.organizeImports')

nnoremap <buffer> <leader>f :OrganizeImport <bar> ALEFix<CR>
