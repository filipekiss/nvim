setlocal linebreak
setlocal conceallevel=0
setlocal spell
setlocal nolist

" Use <C-L> to auto correct current line
" Taken from https://castel.dev/post/lecture-notes-1/
"" [I] <Ctrl>+l -- Auto correct current line
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
