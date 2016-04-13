" Vim compiler file for markdown -> pdf using pandoc

if exists("current_compiler")
    finish
endif
let current_compiler = "pandoc-article"

if exists(":CompilerSet") != 2
    command -nargs=* CompilerSet setlocal <args>
endif

if filereadable('makefile')
    setlocal makeprg=make
else
    CompilerSet makeprg=pandoc\ -S\ --filter\ pandoc-citeproc\ -f\ markdown+hard_line_breaks+emoji+line_blocks\ %\ $HOME/.pandoc/metadata/metadata-article.yaml\ -o\ %<.pdf
endif

" CompilerSet errorformat=%f:%l:\ %m,%f:%l-%\\d%\\+:\ %m
