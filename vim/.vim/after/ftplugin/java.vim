compiler javac

if filereadable("makefile")
    setlocal makeprg=make
else
    setlocal makeprg=javac\ %
endif

setlocal omnifunc=javacomplete#Complete
