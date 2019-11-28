augroup GitFileTypes
    au! BufNewFile,BufRead .gitconfig* set filetype=gitconfig
    au! BufNewFile,BufRead PULLREQ_EDITMSG,ISSUE_EDITMSG set filetype=markdown.gitcommit
augroup end

