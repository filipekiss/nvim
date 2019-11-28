scriptencoding utf-8
" strips trailing whitespace at the end of files. this
" is called on buffer write.
function! functions#Preserve(command)
    " Preparation: save last search, and cursor position.
    let l:pos=getcurpos()
    let l:search=@/
    " Do the business:
    keepjumps execute a:command
    " Clean up: restore previous search history, and cursor position
    let @/=l:search
    nohlsearch
    call setpos('.', l:pos)
endfunction

function! functions#hasFileType(list)
    return index(a:list, &filetype) != -1
endfunction

let g:fckQuitBlackList = ['preview', 'qf', 'fzf', 'netrw', 'help', 'tagbar']
function! functions#should_quit_on_q()
    return functions#hasFileType(g:fckQuitBlackList)
endfunction

let g:fckKeepWhiteSpace = ['markdown']
function! functions#should_strip_whitespace()
    return functions#hasFileType(g:fckKeepWhiteSpace)
endfunction

let g:fckNoLineNumbers = ['tagbar', 'gitcommit', 'fzf', 'startify', 'markdown']
function! functions#displayLineNumbers(mode) abort
    let s:disableNumbersForBuffer = get(b:, 'fckNoLineNumbers', 0)
    if functions#hasFileType(g:fckNoLineNumbers) || (s:disableNumbersForBuffer == 1)
        set nonumber
        set norelativenumber
    else
        if (a:mode ==# 'i')
            set number
            set norelativenumber
        else
            set number
            set relativenumber
        endif
    endif
endfunction

function! functions#NeatFoldText()
    let l:foldchar = matchstr(&fillchars, 'fold:\zs.')
    let l:lines=(v:foldend - v:foldstart + 1) . ' lines'
    let l:first=substitute(getline(v:foldstart), '\v *', '', '')
    let l:dashes=substitute(v:folddashes, '-', l:foldchar, 'g')
    return l:dashes . l:foldchar . l:foldchar . ' ' . l:lines . ': ' . l:first . ' '
endfunction

function! functions#SetProjectDir(...)
    " If we have a buffer project set, just use it and be done with it
    let s:bufferProject= get(b:, 'projectFolder', '')
    if (!empty(s:bufferProject))
      echom 'Using buffer project'
      lcd `=s:bufferProject`
      return 
    endif
    " Get current file dir
    let s:currentDir= (a:0 > 0 ? a:1 : expand('%:p:h'))
    let s:projectFolder = functions#GetProjectDir(s:currentDir)
    " If we have a folder set and the folder is not the current folder, change to it
    if (!empty(s:projectFolder))
        lcd `=s:projectFolder`
        " let b:ale_javascript_xo_options='--cwd=' . s:projectFolder . ' ' . g:ale_javascript_xo_options
        silent echom 'Changed project folder to ' . s:projectFolder
    endif
endfunction

function! functions#GetProjectDir(currentDir)
    " If the directory doesn't exists, don't bother trying to guess stuff and also return an empty
    " string
    if !isdirectory(a:currentDir)
        return ''
    endif
    " Try to get a git top-level directory (this will return $HOME if not inside a git repo)
    let s:gitDir = functions#FindFileIn('.git', a:currentDir)
    let s:gitProjectDir = s:gitDir
    let s:gitProjectDirWeight = len(s:gitDir)
    " Look for a package.json file
    let s:jsProjectDir = functions#FindFileIn('package.json', a:currentDir, s:gitDir)
    let s:jsProjectDirWeight = len(s:jsProjectDir)
    " Look for a .local.vim
    let s:vimProjectDir = functions#FindFileIn('.local.vim', a:currentDir, s:gitDir)
    " Check what is more specific between the git root project, the foler where we found either
    " package.json or .local.vim (basically the longest path wins, because that means it's more
    " specific)
    let s:projectFolder = functions#FindLongestPath([s:gitDir, s:jsProjectDir, s:vimProjectDir])
    return s:projectFolder
endfunction

function! functions#FindLongestPath(paths)
  let s:longestLength = 0
  let s:longestIndex = 0 
  let s:currentIndex = 0
  for s:path in a:paths
    if (len(s:path) > s:longestLength)
      let s:longestLength = len(s:path)
      let s:longestIndex = s:currentIndex
    endif
    let s:currentIndex += 1
  endfor
  return a:paths[s:longestIndex]
endfunction

function! functions#FindFileIn(filename, startingPath, ...)
    let s:searchUntil = get(a:, 1, $HOME)
    " If s:searchUntil is empty by now, means no $HOME is defined. We have no business here
    if (empty(s:searchUntil) || len(a:startingPath) < len(s:searchUntil))
        return ''
    endif
    if (a:filename ==? '.git')
        return GetGitDir(a:startingPath)
    endif
    " If found <filename>, return the current folder
    if filereadable(a:startingPath . '/' . a:filename)
        return a:startingPath
    endif
    " Recursively run this until a:startingPath is equal s:searchUntil
    return functions#FindFileIn(a:filename, fnamemodify(a:startingPath, ':h'), s:searchUntil)
endfunction

function! GetGitDir(path)
    " Set 'gitdir' to be the folder containing .git or an empty string
    let s:gitdir=system('cd '.a:path.' && git rev-parse --show-toplevel 2> /dev/null || echo ""')
    " Clear new-line from system call
    let s:gitdir=substitute(s:gitdir, '.$', '', '')
    if (empty(s:gitdir))
        let s:gitdir = $HOME
    endif
    return s:gitdir
endfunction

function! AutoWrapToggle()
  if &formatoptions =~? 't'
    setlocal formatoptions-=t
    setlocal nowrap
    echo 'nowrap'
  else
    setlocal formatoptions+=t
    setlocal wrap
    echo 'wrap'
  endif
endfunction

function! AppendModeline()
    let l:modeline = printf(' %s: set ts=%d sw=%d tw=%d ft=%s %set :',
                \  'vim', &tabstop, &shiftwidth, &textwidth, &filetype, &expandtab ? '' : 'no')
    let l:modeline = substitute(&commentstring, '%s', l:modeline, '')
    call append(0, l:modeline)
endfunction

function! functions#isGit() abort
    silent call system('git rev-parse')
    return v:shell_error == 0
endfunction

function! functions#ExecuteMacroOverVisualRange()
    echo '@'.getcmdline()
    execute ":'<,'>normal @".nr2char(getchar())
endfunction

function! functions#openMarkdownPreview() abort
    call system('open file://' . expand('%:p'))
endfunction

function! functions#EditExtension(bang, ...)
    let s:name = get(a:, 1, &filetype)

    if (s:name ==# '')
        echoe 'Provide a name for the extension'
        return
    endif

    let s:file = expand($VIMHOME) . '/extensions/' . s:name . '.vim'
    call EditFile(s:file)
endfunction

function! EditFile(file) abort
    let s:mode = 'vs'
    if winwidth(0) <= 2 * (&textwidth ? &textwidth : 80)
        let s:mode = 'sp'
    endif

    execute ':'.s:mode.' '.escape(a:file, ' ')
endfunction

function! Slugify(string) abort
	let l:finalString = a:string
    let l:chars = {
                \ '[[=a=]]': 'a',
                \ '[[=b=]]': 'b',
                \ '[[=c=]]': 'c',
                \ '[[=d=]]': 'd',
                \ '[[=e=]]': 'e',
                \ '[[=f=]]': 'f',
                \ '[[=g=]]': 'g',
                \ '[[=h=]]': 'h',
                \ '[[=i=]]': 'i',
                \ '[[=j=]]': 'j',
                \ '[[=k=]]': 'k',
                \ '[[=l=]]': 'l',
                \ '[[=m=]]': 'm',
                \ '[[=n=]]': 'n',
                \ '[[=o=]]': 'o',
                \ '[[=p=]]': 'p',
                \ '[[=q=]]': 'q',
                \ '[[=r=]]': 'r',
                \ '[[=s=]]': 's',
                \ '[[=t=]]': 't',
                \ '[[=u=]]': 'u',
                \ '[[=v=]]': 'v',
                \ '[[=w=]]': 'w',
                \ '[[=x=]]': 'x',
                \ '[[=y=]]': 'y',
                \ '[[=z=]]': 'z',
    \ }
    for [pattern, replacement] in items(l:chars)
        " Replace accented chars for their non-accented version
		let l:finalString = substitute(l:finalString, pattern, replacement, 'g')
    endfor
	" Replace spaces with '_'
    let l:finalString = substitute(l:finalString, ' ', '_', 'g')
    " Replace non alpha-numeric characters with '-'
    let l:finalString = substitute(l:finalString, '[^a-zA-Z0-9_]', '-', 'g')
    " Squeeze all the '-' characters
    let l:finalString = substitute(l:finalString, '--*', '-', 'g')
    return l:finalString
endfunction


function! functions#has_floating_window() abort
  " MenuPopupChanged was renamed to CompleteChanged -> https://github.com/neovim/neovim/pull/9819
  return (exists('##MenuPopupChanged') || exists('##CompleteChanged')) && exists('*nvim_open_win')
endfunction

function! functions#floating_fzf() abort
  let l:buf = nvim_create_buf(v:false, v:true)
  call setbufvar(l:buf, '&signcolumn', 'no')
  call setbufvar(l:buf, '&filetype', 'fzf')

  let l:height = float2nr(&lines * 0.4)
  let l:width = float2nr(&columns - (&columns * 8 / 40))
  let l:col = float2nr((&columns - width) / 2)

  let l:opts = {
        \ 'relative': 'editor',
        \ 'row': 3,
        \ 'col': l:col,
        \ 'width': l:width,
        \ 'height': l:height
        \ }

  call nvim_open_win(l:buf, v:true, l:opts)
endfunction

function! functions#fzf_window() abort
  return functions#has_floating_window() ? 'call functions#floating_fzf()' : 'enew'
endfunction

function! functions#TabMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr 'no output'
  else
    " use "new" instead of "tabnew" below if you prefer split windows instead of tabs
    tabnew
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message
  endif
endfunction

function! functions#HasMacosApp(appname)
    let app_path=system('mdfind "'.a:appname.'" -onlyin /Applications')
    return app_path !=? ''
endfunction
