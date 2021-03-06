" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/itchyny/lightline.vim')
    finish
endif

if extensions#isMissing('lightline.vim', 'lightline.vim')
    finish
endif


let g:lightline = get(g:, 'lightline', {})

let g:lightline.enable = {
            \ 'statusline': 1,
            \ 'tabline': 1
            \ }

let s:left_status = [
            \ ['mode'],
            \ [ 'filename', 'readonly', 'modified' ] ]

" Don't forget the right status bar is reversed: the first item is the last one
" to show up
let s:right_status =[
            \ [ 'lineinfo' ],
            \ [ 'spellcheck', 'fileformat', 'fileencoding', 'filetype' ] ,
            \ ['linter_ok', 'linter_warnings', 'linter_errors'],
            \ ]

let g:lightline.component_expand = {
            \ 'linter_warnings': 'ale#StatuslineLinterWarnings',
            \ 'linter_errors': 'ale#StatuslineLinterErrors',
            \ 'linter_ok': 'ale#StatuslineLinterOK',
            \ }

let g:lightline.component_function = {
            \ 'filename': 'FilenamePrefix',
            \ 'spellcheck': 'SpellChecker',
            \ }

let g:lightline.component_type = {
            \ 'linter_warnings': 'warning',
            \ 'linter_errors': 'error',
\ }

let g:lightline.active = {
            \ 'left': s:left_status,
            \ 'right': s:right_status,
            \ }

let g:lightline.inactive = {
            \ 'left': [ [ 'filename' ] ],
            \ 'right': [ [ 'lineinfo' ],
            \            [ 'percent' ] ] }
let g:lightline.tabline = {
            \ 'left': [ [ 'tabs' ] ],
            \ 'right': [ [] ] }

function! FilenamePrefix() abort
    " Get path without filename
    let l:basename=expand('%:h')
    " Get custom prefix if set.
    let l:pathPrefix=get(b:, 'fkBufPrefix', fnamemodify(getcwd(), ':t'))
    let l:cwd = getcwd()
    " If the window is outside cwd (mainly used for inactive windows), treat the
    " path to prevent things like vim/~/.vim/file.vim and show .vim/file.vim,
    " for example
    if l:basename =~ l:cwd
        let l:basename = substitute(l:basename, '\C^' . l:cwd . '/', '', '')
    endif
    " Format
    let l:dimmedColor='%#LighlineMiddle_normal#'
    let l:normalColor='%#LightlineLeft_normal_0_1#'
    let l:dimmedColor=''
    let l:normalColor=''
    " Get current filename
    let l:fileName=expand('%:t')

    " If l:pathPrefix is set and doesn't end in /, add a trailing /
    if l:pathPrefix !=? '' && l:pathPrefix !~? '\/$'
        let l:pathPrefix = l:pathPrefix . '/'
    endif
    " If it's a buffer with no filename, show <prefix>/NO NAME
    if l:fileName ==? ''
        return l:dimmedColor . l:pathPrefix . l:normalColor . 'NO NAME'
    endif
    " If we're at the project root, avoid showing the filename with the leading
    " dot (like ./README.md, for example), but still add the prefix if set
    if  l:basename ==? '.'
        return l:dimmedColor . l:pathPrefix . l:normalColor . l:fileName
    endif
    " The `substitute` make sure we show $HOME as ~.
    return  l:dimmedColor . l:pathPrefix . substitute(l:basename . '/', '\C^' . $HOME, '~', '') . l:normalColor . l:fileName
endfunction

function! SpellChecker() abort
    let l:spellcheckEnabled = '𝐒'
    let l:spellcheckDisabled = ''
    if ( &spell )
        return l:spellcheckEnabled
    endif
    return l:spellcheckDisabled
endfunction

if executable('devicon-lookup')
    function! IconFormat() abort
        let l:fileicon = WebDevIconsGetFileTypeSymbol()
        return l:fileicon . ' ' . &filetype
    endfunction

    let g:lightline.component_function.filetype = 'IconFormat'
endif

if functions#HasColorScheme('two-firewatch')
    let g:lightline.colorscheme = 'twofirewatch'
endif

augroup LightLineUpdate
    autocmd!
    autocmd BufEnter * call lightline#update()
augroup END

"# :LightlineReload -- Reload Lightline Configuration [lightline]
command! LightlineReload call LightlineReload()

function! LightlineReload()
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction

