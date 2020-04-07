setlocal linebreak
setlocal conceallevel=0
setlocal spell
setlocal nolist

" Use <C-L> to auto correct current line
" Taken from https://castel.dev/post/lecture-notes-1/
"" [I] <Ctrl>+l -- Auto correct current line
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
if functions#HasMacosApp('Marked')
    "" [N] <Ctrl>+p -- Preview Markdown in Marked.app (macOS only) [macos]
    nnoremap <expr> <C-p> ':silent !open -a Marked ' . expand('%') . '<CR>'
endif

let b:undo_ftplugin = 'setlocal linebreak< conceallevel< spell< nolist<'
