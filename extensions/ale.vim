" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/dense-analysis/ale')
    finish
endif

if extensions#isMissing('ale')
    finish
endif

let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_text_changed = 'normal'
let g:ale_open_list = 0
let g:ale_set_signs = 1
let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_virtualtext_cursor = 0
let g:ale_virtualtext_prefix = ' ' " \uf687
" The icons are in order of precedence
let g:ale_sign_error = '' " \uf66f
let g:ale_sign_warning = '' " \uf66b
let g:ale_sign_info = '' " \uf129
let g:ale_sign_style_error  = '' " \uf48f
let g:ale_sign_style_warning  = '' " \uf77b
let g:ale_statusline_format = ['E•%d', 'W•%d', 'OK']
let g:ale_echo_msg_format = '%linter% %severity%% (code)% - %s'
let g:ale_echo_msg_error_str = g:ale_sign_error
let g:ale_echo_msg_info_str = g:ale_sign_info
let g:ale_echo_msg_warning_str = g:ale_sign_warning
let g:ale_javascript_eslint_suppress_missing_config = 1
let g:ale_javascript_eslint_suppress_eslintignore = 1
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_linters_explicit = 1
function! s:PRETTIER_OPTIONS()
  return '--config-precedence prefer-file --single-quote --no-bracket-spacing --prose-wrap always --trailing-comma all --semi --end-of-line  lf --print-width ' . &textwidth
endfunction
let g:ale_javascript_prettier_options = <SID>PRETTIER_OPTIONS()
augroup PrettierTextWidth
    " Auto update the option when textwidth is dynamically set or changed in a ftplugin file
    au! OptionSet textwidth let g:ale_javascript_prettier_options = <SID>PRETTIER_OPTIONS()
augroup END

let g:ale_linters = {
            \ 'javascript' : ['eslint'],
            \ 'typescript' : ['eslint'],
            \ 'vim'        : ['vint'],
            \ 'markdown'   : ['alex'],
            \ 'sh'         : ['shellcheck'],
            \ 'bash'       : ['shellcheck'],
            \}

let g:ale_fixers = {
            \ 'markdown'       : ['prettier'],
            \ 'javascript'     : ['prettier'],
            \ 'javascript.jsx' : ['prettier'],
            \ 'javascriptreact' : ['prettier'],
            \ 'typescript'     : ['prettier'],
            \ 'typescript.tsx' : ['prettier'],
            \ 'typescriptreact' : ['prettier'],
            \ 'json'           : ['prettier'],
            \ 'css'            : ['prettier'],
            \ 'scss'           : ['prettier'],
            \ 'html'           : ['prettier'],
            \ 'graphql'        : ['prettier'],
            \ 'sh'             : ['shfmt'],
            \ 'bash'           : ['shfmt'],
            \}

" Don't auto fix (format) files inside `node_modules`, minified files and jquery (for legacy codebases)
" Also, don't lint markdown files that end in a pattern that resembles
" a language code (for example index.pt.md or index.pt-br.md) because `alex`
" only understands english
let g:ale_pattern_options_enabled = 1
let g:ale_pattern_options = {
            \   '\.min\.(js\|css)$': {
            \       'ale_linters': [],
            \       'ale_fixers': []
            \   },
            \   'jquery.*': {
            \       'ale_linters': [],
            \       'ale_fixers': []
            \   },
            \   'node_modules/.*': {
            \       'ale_linters': [],
            \       'ale_fixers': []
            \   },
            \   '.*\.[a-z]{2}(-[a-z]{2})?\.md': {
            \       'ale_linters': [],
            \   },
            \}

function! ale#StatuslineLinterWarnings() abort
    if g:ale_is_linting == 1
        return ''
    endif
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    return l:counts.total == 0 ? '' : printf('%d %s', all_non_errors, g:ale_sign_warning)
endfunction

function! ale#StatuslineLinterErrors() abort
    if g:ale_is_linting == 1
        return ''
    endif
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    return l:counts.total == 0 ? '' : printf('%d %s', all_errors, g:ale_sign_error)
endfunction

function! ale#StatuslineLinterOK() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    let l:is_ok = l:counts.total == 0 ? '' : '' " \uf45e
    if (g:ale_is_linting)
        return '' " \uf499
    endif
    if (g:ale_is_fixing)
        return '' " \uf46b
    endif
    return l:is_ok
endfunction

if extensions#isInstalled('lightline.vim', 'lightline.vim')
    augroup ALEStatus
        autocmd!
        autocmd User ALELintPre let g:ale_is_linting = 1 | call lightline#update()
        autocmd User ALELintPost let g:ale_is_linting = 0 | call lightline#update()
        autocmd User ALEFixPre let g:ale_is_fixing = 1 | call lightline#update()
        autocmd User ALEFixPost let g:ale_is_fixing = 0 | call lightline#update()
    augroup end
endif

" Commands to toggle ALE Fixers.
" See https://github.com/w0rp/ale/issues/1353
"# :ALEDisableFixers -- Disable Ale Fixers globally [ale]
"# :ALEEnableFixers -- Enable Ale Fixers globally [ale]
"# :ALEDisableFixersBuffer -- Disable Ale Fixers for current buffer [ale]
"# :ALEDisableFixersBuffer -- Enable Ale Fixers for current buffer [ale]
command! ALEDisableFixers       let g:ale_fix_on_save=0
command! ALEEnableFixers        let g:ale_fix_on_save=1
command! ALEDisableFixersBuffer let b:ale_fix_on_save=0
command! ALEEnableFixersBuffer  let b:ale_fix_on_save=1

"" [N] <leader>l -- Lint current file [ALE]
nmap <silent> <leader>l :ALELint<CR>
"" [N] <leader>f -- Fix current file [ALE]
nmap <silent> <leader>f :ALEFix<CR>
"" [N] ]c -- Go to next linter warning/error [ALE]
nmap <silent> ]c :ALENextWrap<CR>
"" [N] [c -- Go to previous linter warning/error [ALE]
nmap <silent> [c :ALEPreviousWrap<CR>
