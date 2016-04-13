" Vim compiler file for markdown -> reveal.js using pandoc

if exists("current_compiler")
    finish
endif
let current_compiler = "pandoc-slides"

if exists(":CompilerSet") != 2
    command -nargs=* CompilerSet setlocal <args>
endif

if filereadable('makefile')
    setlocal makeprg=make
else
    CompilerSet makeprg=pandoc\ --mathjax\ --filter\ pandoc-citeproc\ -t\ revealjs\ -f\ markdown+hard_line_breaks+emoji+line_blocks\ -V\ revealjs-url=$HOME/.pandoc/lib/reveal.js\ $HOME/.pandoc/metadata/metadata-slides.yaml\ -s\ %\ -o\ %<.html
endif

" CompilerSet errorformat=%f:%l:\ %m,%f:%l-%\\d%\\+:\ %m
