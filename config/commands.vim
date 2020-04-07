scriptencoding utf-8

" ┌──────────────────────────────────────────────────┐
" │ Make these commonly mistyped commands still work │
" └──────────────────────────────────────────────────┘
command! WQ wq
command! Wq wq
command! Wqa wqa
command! W w
command! Q q

" ┌──────────────────────────┐
" │ Use :C to clear hlsearch │
" └──────────────────────────┘
"# :C -- Clear hlsearch
command! C nohlsearch

"# :Del -- Delete current file and clear the buffer
command! Del :call delete(@%) | bdelete!

" ┌───────────────────────────────────────┐
" │ Force write readonly files using sudo │
" └───────────────────────────────────────┘
command! WS w !sudo tee %

"# :FormatJSON -- Format JSON in current buffer
command! FormatJSON %!python -m json.tool

"# :EditExtension <name> -- Edit the extension file with the given name
command! -bang -nargs=? -complete=customlist,extensions#ListExtensions EditExtension :call functions#EditExtension(<q-bang>, <q-args>)

"# :ReloadExtensions -- Reload and install missing extensions
command! ReloadExtensions :call extensions#reload()

"# :TabMessage -- Redirect the output of a command to a new tab
command! -nargs=+ -complete=command TabMessage call functions#TabMessage(<q-args>)

" Create a private gist with the contents of the current buffer. A name must be
" supplied. Autocomplete current names and opens the gist on default browser
"# :Gist <filename> -- Creates a private gist using the gist binary (http://defunkt.io/gist/) 
command! -range=% -nargs=1 -complete=file Gist :<line1>,<line2>w !gist -p -o -f <q-args>

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang Find call RipgrepFzf(<q-args>, <bang>0)
