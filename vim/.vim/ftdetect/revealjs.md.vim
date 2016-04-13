autocmd! BufRead,BufNewFile,BufFilePre *.revealjs.md setlocal filetype=markdown.pandoc
autocmd! BufRead,BufNewFile,BufFilePre *.revealjs.md compiler pandoc-slides-revealjs
