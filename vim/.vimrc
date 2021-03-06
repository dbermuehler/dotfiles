if has('win32') || has ('win64')
    let $VIMHOME = $HOME."/vimfiles"
    let $MDCTAGS = $HOME."/bin/markdown2ctags.py"
    let $PATHSEPERATOR = "\\"
else
    let $VIMHOME = $HOME."/.vim"
    let $MDCTAGS = "/usr/bin/markdown2ctags"
    let $PATHSEPERATOR = "/"
endif

" Settings
set encoding=utf-8
set noswapfile
set nobackup
set nowritebackup
set backspace=indent,eol,start " allow backspacing over autoindent, line breaks and the beginning of insert mode
set history=50
set fileformats=unix,dos
set mouse=a " enables mouse support in all modes
set clipboard=unnamed " access X clipboard via the * and + registera, vim needs to be compiled with this feature
set hidden " Allow switching edited buffers without saving
set completeopt=menu,preview,longest
set autoread " if a file outside of the current vim session is modified it can be read in by :checktime, see :help E321
set modelines=1 " activate per-file-settings
set path=$PWD/**
set autochdir

if !isdirectory($HOME.'/.vimundo/')
    call mkdir($HOME.'/.vimundo/', "p")
endif
set undofile " activates persistent undo
set undodir=~/.vimundo/ " if undofile is activated, a directory is needed where the undofiles are stored

" vim gui stuff
set showmatch " show matching brackets/parenthesis
set ruler " shows line numbers in statusbar
set number " show line numbers"
set showcmd " show entered command in normal mode
set showmode
set ttyfast " send more characters for redraws
set scrolloff=3 " shows the next or previous 3 lines under or above the cursor
set scroll=10
set novisualbell
set t_Co=256 " activate 256 color support if your terminal supports it and haven't configured to use it
"set listchars=tab:>-,trail:.,eol:$ " characters for tab, trailing spaces and eol when activate 'set list'
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮ " characters for tab, eol, etc. when activate 'set list'
set lazyredraw " Dont update viewport until the marco has completed for faster processing.
set background=dark

"soft line wrap
set wrap
set linebreak

set wildmenu
set wildmode=longest:full,full " first tab complete only longest common string, second tab complete to first element in list
set wildignorecase " completion on files in command mode is now case insensitive
set wildignore+=*.aux,*.toc " LaTeX intermediate files
set wildignore+=*.class " java class files

" searching
set incsearch " find as you type search
set ignorecase " do not search case sensitive
set smartcase " Case sensitive if we type an uppercase
set hlsearch

" tabs -> spaces
set expandtab " tabs will be spaces
set tabstop=4 " one tab is 4 spaces
set shiftwidth=4 " indention will be 4 spaces
set smarttab " backspace over tabs

" filetype
set autoindent
set copyindent " copy the previous indentation on autoindenting
syntax on
filetype plugin on " apply settings based on filetype
filetype indent on " indention for known file extensions
set omnifunc=syntaxcomplete#Complete

let g:tex_flavor = 'latex' " set the flavor for tex files to latex for correct syntax highlighting etc.
let g:markdown_fenced_languages = ['xml', 'html', 'sql', 'python', 'java', 'tex', 'bash=sh', 'javascript', 'js=javascript'] " enables syntax highlighting for these languages in markdown code blocks
let g:netrw_browsex_viewer = "xdg-open"
let g:xml_syntax_folding=1

augroup filetype_settings
    autocmd!
    autocmd FileType sql setlocal commentstring=--\ %s
    autocmd FileType xdefaults setlocal commentstring=\!\ %s
    autocmd FileType xml setlocal foldmethod=syntax

    autocmd FileType {json,yaml} setlocal tabstop=2
    autocmd FileType {json,yaml} setlocal shiftwidth=2

    " Set correct filetype for external editing of the commandline content when invoking 'v' in bashs vi mode
    autocmd BufRead,BufNewFile bash-fc-* setlocal filetype=sh
    autocmd BufRead,BufNewFile *Xresources.local setlocal filetype=xdefaults

    autocmd BufRead,BufNewFile Dockerfile* setlocal filetype=dockerfile
    autocmd BufRead,BufNewFile Dockerfile* setlocal tabstop=2
    autocmd BufRead,BufNewFile Dockerfile* setlocal shiftwidth=2

    autocmd BufRead,BufNewFile .eslintrc setlocal tabstop=2
    autocmd BufRead,BufNewFile .eslintrc setlocal shiftwidth=2

    autocmd BufRead,BufNewFile *.tsv setlocal noexpandtab
augroup END

" Custome key mappings
nnoremap <leader>b :ls<CR>:b<Space>
nnoremap <leader>wf :let @* = expand("%:p")<CR>:echo "Copied current filepath to clipboard..."<CR>
nnoremap <leader>wd :let @* = getcwd() . $PATHSEPERATOR<CR>:echo "Copied current working dir path to clipboard..."<CR>

" use the arrow key to move between windows
nnoremap <Left> <C-w>h
nnoremap <Down> <C-w>j
nnoremap <Up> <C-w>k
nnoremap <Right> <C-w>l

" because of soft wrap
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" clears the last search pattern to disable highlighting
map <silent> <leader>h :let @/ = ""<CR>
map <silent> <leader>s :setlocal invspell spell?<CR>
map <silent> <leader>r :source ~/.vimrc<CR>
map <leader>p :set invpaste paste?<CR>

function! Run(...)
    let args = ''
    for i in a:000
       let args = args . ' ' . i
    endfor

    execute "write"

    if &filetype == "sh"
        execute "!bash "  . args . " " . expand("%")
    elseif &filetype == "python"
        execute "!python " . args . " " . expand ("%")
    elseif &filetype == "html"
        execute "silent! !xdg-open " . expand("%") . " >& /dev/null"
    else
        echoerr "Error: Run() isn't defined for this filetype."
    endif

    execute "redraw!"
endfunction

command! -nargs=* Run call Run(<f-args>)

if filereadable($VIMHOME."/autoload/plug.vim")
    let g:plug_threads = 50

    " Plug Settings
    call plug#begin($VIMHOME."/plugged")

    " UI Plugins
    Plug 'majutsushi/tagbar'
    Plug 'inside/vim-search-pulse'
    Plug 'mhinz/vim-signify'

    " Editing Plugins
    Plug 'jiangmiao/auto-pairs'
    Plug 'ntpeters/vim-better-whitespace'
    Plug 'tpope/vim-commentary'

    " Movement Plugins
    Plug 'matze/vim-move'
    Plug 'andrewradev/sideways.vim'

    " Syntax Plugins
    Plug 'Matt-Deacalion/vim-systemd-syntax'

    if v:version >= 704
        set breakindent

        if has('unix') || has ('macunix')
            Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
            Plug 'junegunn/fzf.vim'
        endif
    endif

    " Colorschemes
    Plug 'w0ng/vim-hybrid'

    call plug#end()

    " Plugin settings
    let g:move_key_modifier = 'C'

    let g:tagbar_left = 1
    let g:tagbar_width = 25
    let g:tagbar_zoomwidth = 50

    if filereadable($MDCTAGS)
        let g:tagbar_type_markdown = {
            \ 'ctagstype': 'markdown',
            \ 'ctagsbin' : $MDCTAGS,
            \ 'ctagsargs' : '-f - --sort=yes',
            \ 'kinds' : [
                \ 's:sections',
                \ 'i:images'
            \ ],
            \ 'sro' : '|',
            \ 'kind2scope' : {
                \ 's' : 'section',
            \ },
            \ 'sort': 0,
        \ }
    endif

    " Custome key mappings
    map <F2> :Tagbar<CR>
    map ° :Ag <c-r>=expand("<cword>")<cr><cr>

    nnoremap <c-h> :SidewaysLeft<cr>
    nnoremap <c-l> :SidewaysRight<cr>
endif

try
    colorscheme hybrid
catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme desert
endtry

if filereadable($HOME."/.vimrc.local")
    source $HOME/.vimrc.local
endif
