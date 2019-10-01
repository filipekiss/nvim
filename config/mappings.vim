scriptencoding utf-8

" ┌────────┐
" │ Leader │
" └────────┘
let g:mapleader="\<Space>"

" ┌──────────────────────┐
" │ Cursor/Text Movement │
" └──────────────────────┘

" Disable arrow keys (hardcore)
nmap  <up>    <nop>
nmap  <down>  <nop>
nmap  <left>  <nop>
nmap  <right> <nop>

" Make arrowkey do something usefull, resize the viewports accordingly
"" [N] <Left> -- Make window larger horizontally
"" [N] <Right> -- Make window smaller horizontally
"" [N] <Up> -- Make window bigger vertically
"" [N] <Down> -- Make window smaller vertically
nnoremap <Left> :vertical resize +2<CR>
nnoremap <Right> :vertical resize -2<CR>
nnoremap <Up> :resize +2<CR>
nnoremap <Down> :resize -2<CR>

" Treat overflowing lines as having line breaks.
map <expr> j v:count ? 'j' : 'gj'
map <expr> k v:count ? 'k' : 'gk'

" Quickly move current line up/down, also accepts counts 2<leader>j
"" [N] <leader>j -- Move current line {count}lines down
"" [N] <leader>k -- Move current line {count}lines up
nnoremap <leader>j :<c-u>execute 'move +'. v:count1<cr>
nnoremap <leader>k :<c-u>execute 'move -1-'. v:count1<cr>

" Make `Y` behave like `C` and `D` (to the end of line)
"" [N] Y -- Copy from curent cursor position until EOL
nnoremap Y y$

" keep search matches in the middle of the window.
nmap n nzz
nmap N Nzz

" https://github.com/mhinz/vim-galore#dont-lose-selection-when-shifting-sidewards
xnoremap <  <gv
xnoremap >  >gv

" Don't move cursor when yanking stuff!
" See http://ddrscott.github.io/blog/2016/yank-without-jank/
vnoremap <expr>y "my\"" . v:register . "y`y"

" Add line to the beggining/end of the file. Add a mark o/O to make it easy to get back to where you
" were
"" [N] <Leader>o -- Add a line at the beggining of the file
"" [N] <Leader>O -- Add a line at the end of file
nnoremap <Leader>o moGGo
nnoremap <Leader>O mOggO

" Easily move to beggining and end of the line
" https://github.com/shelldandy/dotfiles/blob/master/config/nvim/keys.vim#L114
"" [N] H -- Go to the beggining of the line
"" [N] L -- Go the the end of the line
nnoremap H ^
nnoremap L $

" ┌──────────────────────┐
" │ Insert mode mappings │
" └──────────────────────┘

" Make better undo chunks when writing long texts (prose) without exiting insert mode.
" :h i_CTRL-G_u
" https://twitter.com/vimgifs/status/913390282242232320
inoremap . .<c-g>u
inoremap ? ?<c-g>u
inoremap ! !<c-g>u
inoremap , ,<c-g>u

" Pressing up/down exits insert mode
inoremap <silent> <Up> <ESC>
inoremap <silent> <Down> <ESC>

" ┌────────────────────────┐
" │ Window/Buffer Mappings │
" └────────────────────────┘

" Use CTRL+[HJKL] to navigate between panes, instead of CTRL+W CTRL+[HJKL]
"" [N] <C-h> -- Go to pane to the right of the current one
"" [N] <C-j> -- Go to the pane below current one
"" [N] <C-k> -- Go to the pane above current one
"" [N] <C-l> -- Go to the pane to the left of the current one
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>

"" [N] <Bar> -- Split window vertically
"" [N] _ -- Split Window Horizontally
nnoremap <expr><silent> <Bar> v:count == 0 ? "<C-W>v<C-W><Right>" : ":<C-U>normal! 0".v:count."<Bar><CR>"
nnoremap <expr><silent> _     v:count == 0 ? "<C-W>s<C-W><Down>"  : ":<C-U>normal! ".v:count."_<CR>"

"" [N] <tab> -- Next buffer
"" [N] <S-tab> -- Previous buffer
nnoremap <tab>   :bnext<CR>
nnoremap <S-tab> :bprevious<CR>

" ┌──────────────────┐
" │ Utility Mappings │
" └──────────────────┘

" If vim is in diff mode, close all buffers. Otherwhise, :quit
nnoremap <expr><silent> <leader>q &diff ? ":windo bd<CR>" : ":quit<CR>"

" https://github.com/mhinz/vim-galore#quickly-edit-your-macros
"" [N] <leader>m -- Edit the macro on any register (default *)
nnoremap <leader>m  :<c-u><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>

"" [N] <leader>tw -- Toggle text wrapping
nnoremap <silent> <leader>tw :set invwrap<CR>:set wrap?<CR>

" Resolve possible vimrc symlinks
let $MYVIMRC = resolve(expand($MYVIMRC))
"" [N] <leader>ev -- Edit $MYVIMRC
nnoremap <leader>ev :e $MYVIMRC<CR>

"" [N] <Leader>p -- Open latest closed file
nnoremap <Leader>p :e#<CR>

"" [N] <Leader>n -- New file in the current folder
nnoremap <Leader>n :e <C-R>=expand("%:p:h") . "/" <CR>

"" [N] Q -- Repeat last macro
nnoremap Q @@

"" [N] <leader>$ -- Remove trailing spaces
nnoremap <leader>$ :call functions#Preserve("%s/\\s\\+$//e")<CR>
"" [N] <leader>= -- Reindent file
nnoremap <leader>= :call functions#Preserve("normal gg=G")<CR>
"" [N] <leader><CR> -- Join multiple empty lines, leaving just one
nnoremap <leader><CR> :call functions#Preserve("g/^$/,/./-j")<CR>

" https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db#.3dcn9prw6
"" [X] @ -- Run macro in all selected lines
xnoremap @ :<C-u>call functions#ExecuteMacroOverVisualRange()<CR>

" Make the dot command work as expected in visual mode (via
" https://www.reddit.com/r/vim/comments/3y2mgt/do_you_have_any_minor_customizationsmappings_that/cya0x04)
vnoremap . :norm.<CR>

" Don't overwrite register on paste
xnoremap p "_dP

" Slugify word under cursor
nnoremap <silent> <Plug>SlugifyNormal ciw<C-R>=Slugify(getreg('"'))<CR> :silent! call repeat#set("\<Plug>SlugifyNormal")<CR>
vnoremap <silent> <Plug>SlugifyVisual c<C-R>=Slugify(getreg('"'))<CR> :silent! call repeat#set("\<Plug>SlugifyVisual")<CR>
"" [N] <leader>s -- 'Slugify' word under cursor
nmap <silent> <leader>s <Plug>SlugifyNormal
"" [V] <leader>s -- 'Slugify' selected text
vmap <silent> <leader>s <Plug>SlugifyVisual

"" [N] <Leader>R -- Save and source current file
nnoremap <Leader>R :w<CR> :source % \| echom "Reloaded " . expand("%") <CR>

" Make zC fold recursively
nnoremap zC :foldc! \| .,+1foldc!<CR>

"" [N] <leader>i -- Insert before current word under the cursor
nnoremap <leader>i bi

"" [N] <leader>a -- Insert after current word under the cursor
nnoremap <leader>a ea
