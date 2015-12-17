" Vim compiler file for tex using rubber
" Last Change: 2014 Jul 26
" License:     This file is placed in the public domain.

if exists("current_compiler")
  finish
endif
let current_compiler = "rubber"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

if filereadable('makefile')
  setlocal makeprg=make
else
  CompilerSet makeprg=make\ -f\ $HOME/.makefiles/latex_makefile
endif

CompilerSet errorformat=%f:%l:\ %m,%f:%l-%\\d%\\+:\ %m
