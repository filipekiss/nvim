" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/filipekiss/cursed.vim')
    finish
endif

augroup CursedCursorLine
    autocmd!
    autocmd WinEnter *  if !cursed#is_disabled() | set cursorline | endif
    autocmd User CursedStartedMoving :set nocursorline
    autocmd User CursedStoppedMoving :set cursorline
    autocmd WinEnter,WinLeave * :silent DisableBlameLine
    autocmd User CursedStartedMoving :silent DisableBlameLine
    autocmd User CursedStoppedMoving :silent EnableBlameLine
augroup END


