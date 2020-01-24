" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' })
    call extensions#loadExtension('https://github.com/junegunn/fzf.vim')
    finish
endif

if extensions#isMissing('fzf.vim', 'fzf.vim')
    finish
endif
let g:fzf_action = {
            \ 'return': 'tabedit',
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-x': 'split',
            \ 'ctrl-v': 'vsplit',
            \ 'ctrl-e': 'edit'
            \}

let g:fzf_files_options = $FZF_CTRL_T_OPTS
let g:fzf_layout = { 'window': functions#fzf_window() }
let g:fzf_commits_log_options = substitute(system("git config --get alias.l | awk '{$1=\"\"; print $0;}'"), '\n\+$', '', '')
let g:fzf_history_dir = '~/.fzf-history'

command! Plugs call fzf#run({
            \ 'source':  map(sort(keys(g:plugs)), 'g:plug_home."/".v:val'),
            \ 'options': '--delimiter / --nth -1',
            \ 'sink':    'Explore',
            \ 'window': functions#fzf_window(),
            \ })

command! IMaps call fzf#vim#maps('i')

"" [N] <leader><leader> -- List current project files [fzf]
nnoremap <silent><expr> <leader><leader> functions#isGit() ? ':GFiles<CR>' : ':Files<CR>'
"" [N] <Leader>b -- List open buffers [fzf]
nnoremap <silent> <Leader>b :Buffers<cr>
"" [N] <leader>s -- Show files that were changed on git [fzf]
nnoremap <silent><expr> <leader>s functions#isGit() ? ':GFiles?<CR>' : ':Files<CR>'

function! s:fzf_statusline()
    " Override statusline as you like
    setlocal statusline=%4*\ fzf\ %6*V:\ ctrl-v,\ H:\ ctrl-x
endfunction

" Stolen from here
" https://github.com/ahmedelgabri/dotfiles/blob/f4423acc248e891f7b0314e193028c50ab2e8214/files/.vim/after/plugin/fzf.vim#L38-L45
augroup FzfStatus
    autocmd!
    autocmd User FzfStatusLine call <SID>fzf_statusline()
augroup end

function! FzfSpellSink(word)
    exe 'normal! "_ciw'.a:word
endfunction

function! FzfSpell()
    let suggestions = spellsuggest(expand('<cword>'))
    return fzf#run({'source': suggestions, 'sink': function('FzfSpellSink'), 'down': 10 })
endfunction
"" [N] z= -- Show spell suggestions [fzf]
nnoremap z= :call FzfSpell()<CR>

" This is here mostly thanks to https://coreyja.com/vim-fzf-with-devicons/
if executable('devicon-lookup')
    let s:bindings = '--expect=ctrl-t,ctrl-v,ctrl-x,ctrl-e --delimiter :'

    let s:default_action = {
                \ 'ctrl-t': 'tab split',
                \ 'ctrl-x': 'split',
                \ 'ctrl-v': 'vsplit',
                \ 'ctrl-e': 'edit'}

    function! s:action_for(key, ...)
        let default = a:0 ? a:1 : 'tab split'
        let Cmd = get(get(g:, 'fzf_action', s:default_action), a:key, default)
        return type(Cmd) == type('') ? Cmd : default
    endfunction

    function! s:handle_filename(filename, pad)
        let size = a:pad
        return a:filename[size:-1]
    endfunction

    function! Fzf_files_with_dev_icons(command)
        let l:fzf_files_options = s:bindings . ' --preview "bat --color always --style numbers {2..} | head -'.&lines.'"'
        function! s:edit_devicon_prepended_file(name)
            if len(a:name) < 2 | return | endif

            let s:cmd = s:action_for(a:name[0])
            for file in a:name[1:-1]
                execute 'silent '.s:cmd.' '.s:handle_filename(file, 4)
            endfor
        endfunction

        let l:fzf_options = {
                    \ 'source': a:command.' | devicon-lookup',
                    \ 'sink*':   function('s:edit_devicon_prepended_file'),
                    \ 'options': '-m ' . l:fzf_files_options
                    \}
        if  exists('g:fzf_layout')
            call extend(l:fzf_options, g:fzf_layout)
        endif
        call fzf#run(l:fzf_options)
    endfunction

    function! Fzf_git_diff_files_with_dev_icons()
        let l:fzf_files_options = s:bindings . ' --ansi --preview "sh -c \"(git diff --color=always -- {3..} | sed 1,4d; bat --color always --style numbers {3..}) | head -'.&lines.'\""'
        function! s:edit_devicon_prepended_file_diff(name)
            if len(a:name) < 2 | return | endif

            let s:cmd = s:action_for(a:name[0])
            for file in a:name[1:-1]
                let l:file_path = s:handle_filename(file, 7)
                let l:first_diff_line_number = system('git diff -U0 '.l:file_path." | rg '^@@.*\+' -o | rg '[0-9]+' -o | head -1")
                execute 'silent '.s:cmd.' '.l:file_path
                execute l:first_diff_line_number
            endfor
        endfunction

        let l:fzf_options = {
                    \ 'source': 'git -c color.status=always status --short --untracked-files=all | devicon-lookup',
                    \ 'sink*':   function('s:edit_devicon_prepended_file_diff'),
                    \ 'options': '-m ' . l:fzf_files_options,}
        if  exists('g:fzf_layout')
            call extend(l:fzf_options, g:fzf_layout)
        endif
        call fzf#run(l:fzf_options)
    endfunction

    function! Fzf_GitFiles_Devicons(args, ...)
        if a:args !=? '?'
            call Fzf_files_with_dev_icons('git ls-files --others --no-ignored --exclude-standard --cached|uniq')
            return
        endif
        call Fzf_git_diff_files_with_dev_icons()
    endfunction
    " Overwrite :Files/:GFiles/:GitFiles commands from fzf
    command! -nargs=? Files  :call Fzf_files_with_dev_icons($FZF_DEFAULT_COMMAND)
    command! -nargs=? GFiles  :call Fzf_GitFiles_Devicons(<q-args>, <bang>0)
    command! -nargs=? GitFiles :call Fzf_GitFiles_Devicons(<q-args>, <bang>0)
endif
