" vim: ft=vim :tw=80 :sw=4

scriptencoding utf-8

if extensions#isInstalling()
    call extensions#loadExtension('https://github.com/filipekiss/cursed.vim')
    finish
endif

augroup CursedCursorLine
    autocmd WinEnter * set cursorline
    autocmd User CursedStartedMoving :set nocursorline
    autocmd User CursedStoppedMoving :set cursorline
augroup END


