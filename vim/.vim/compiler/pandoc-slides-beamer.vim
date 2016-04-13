" Vim compiler file for markdown -> beamer using pandoc

if exists("current_compiler")
    finish
endif
let current_compiler = "pandoc-slides-beamer"

if exists(":CompilerSet") != 2
    command -nargs=* CompilerSet setlocal <args>
endif

if filereadable('makefile')
    setlocal makeprg=make
else
    CompilerSet makeprg=pandoc\ --filter\ pandoc-citeproc\ -t\ beamer\ -f\ markdown+hard_line_breaks+emoji+line_blocks\ -V\ theme:Dresden\ $HOME/.pandoc/metadata/metadata-slides.yaml\ -s\ %\ -o\ %<.pdf
endif

" CompilerSet errorformat=%f:%l:\ %m,%f:%l-%\\d%\\+:\ %m
