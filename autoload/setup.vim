" vim: ft=vim :tw=80 :sw=4

function! setup#init() abort
    if has('nvim')
	" Set python binaries for nvim
        let g:python_host_skip_check = 1
        let g:python3_host_skip_check = 1
        let g:loaded_python_provider = 0 " Disable Python 2
        if executable('python3')
            let g:python3_host_prog = exepath('python3')
        endif
        if executable('volta')
            " Make sure `volta install neovim` works as expected
            " See https://github.com/volta-cli/volta/issues/606 for more info
            let g:node_host_prog = '/Users/kissf/.volta/bin/neovim-node-host'
        endif
    endif
    call extensions#install()
    call extensions#installCleanup(1)
    call setup#pathSettings()
    call setup#overrides()
    call setup#load('settings')
    call setup#load('commands')
    call setup#load('mappings')
    call setup#load('autocmds')
    call setup#load('colors')
    call extensions#configure()
    lua require 'init'
endfunction

function! setup#load(file) abort
    let s:filePath = $VIMHOME . '/config/' . a:file . '.vim'
    if filereadable(s:filePath)
        execute 'source ' . s:filePath
    endif
endfunction

function! setup#overrides() abort
    " Local overrides
    let s:vimrc_local = $HOME . '/.local.vim'
    if filereadable(s:vimrc_local)
        execute 'source ' . s:vimrc_local
    endif

    " Project specific override
    let s:vimrc_project_folder = functions#FindFileIn('.local.vim', getcwd())
    let s:vimrc_project = s:vimrc_project_folder . '/.local.vim'
    if filereadable(s:vimrc_project) && s:vimrc_project !=? s:vimrc_local
        execute 'source ' . s:vimrc_project
    endif
endfunction

function! setup#pathSettings() abort
    " Add current folder to path (and subfolders also)
    set path+=**
    set path+=.**
endfunction
