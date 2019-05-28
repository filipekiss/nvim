" vim: ft=vim :tw=80 :sw=4
scriptencoding utf-8

let s:coc_extensions = [
            \ 'coc-css',
            \ 'coc-emmet',
            \ 'coc-highlight',
            \ 'coc-html',
            \ 'coc-json',
            \ 'coc-lists',
            \ 'coc-tsserver',
            \ 'coc-ultisnips',
            \ ]


function! s:coc_hook(info) abort
    call coc#util#install()
    call coc#util#install_extension(get(s:, 'coc_extensions', []))
endfunction

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/Shougo/neco-vim')
    call extensions#loadExtension('https://github.com/neoclide/coc-neco')
    call extensions#loadExtension('https://github.com/neoclide/coc.nvim', { 'tag': '*', 'do': function('s:coc_hook') })
    finish
endif

let g:coc_snippet_next='<c-j>'
let g:coc_snippet_prev='<c-k>'

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

"" [I] <TAB> -- Autocomplete Trigger / Next Suggestion [coc]
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
"" [I] <expr><S-TAB> -- Previous Suggestion [coc]
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"" [I] <c-space> -- Refresh suggestions [coc]
inoremap <silent><expr> <c-space> coc#refresh()


" Remap keys for gotos
" gd - go to definition of word under cursor
"" [N] gd -- Go to definition [coc]
nmap <silent> gd <Plug>(coc-definition)
"" [N] gy -- To to type definition [coc]
nmap <silent> gy <Plug>(coc-type-definition)
"" [N] gi -- Go to implementation [coc]
nmap <silent> gi <Plug>(coc-implementation)
"" [N] gr -- Show references [coc]
nmap <silent> gr <Plug>(coc-references)

" Use K or gh for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
nnoremap <silent> gh :call <SID>show_documentation()<CR>

" List errors
"" [N] <leader>cl -- List linter errors [coc]
nnoremap <silent> <leader>cl :<C-u>CocList locationlist<cr>

" list commands available in tsserver (and others)
"" [N] <leader>cc -- List available commands [coc]
nnoremap <silent> <leader>cc :<C-u>CocList commands<cr>

" restart when tsserver gets wonky
"" [N] <leader>cR -- Restart Completion Service [coc]
nnoremap <silent> <leader>cR :<C-u>CocRestart<CR>

" manage extensions
"" [N] <leader>cx -- Manage COC Extensions [coc]
nnoremap <silent> <leader>cx :<C-u>CocList --normal extensions<cr>

" rename the current word in the cursor
"" [N] <leader>cr -- Rename word under cursos [coc]
nmap <leader>cr  <Plug>(coc-rename)

" Expand snippets
"" [V] <TAB> -- Expand snippet [coc]
vmap <TAB> <Plug>(coc-snippets-select)

function! s:show_documentation()
    if (&filetype ==# 'vim' || &filetype ==# 'help')
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

" Show signature help while editing
augroup COC_SIGNATURE
    autocmd!
    " Update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    autocmd CursorHold * silent call CocActionAsync('highlight')
augroup end
