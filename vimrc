set nocompatible
syntax on
filetype plugin indent on
compiler ruby

set hlsearch
set number
set showmatch
set incsearch
set background=dark
set hidden
set backspace=indent,eol,start
set textwidth=0 nosmartindent tabstop=2 shiftwidth=2 softtabstop=2 expandtab

let html_use_css=1
let html_number_lines=0

let g:clj_highlight_builtins = 1

let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1

let g:rubycomplete_buffer_loading = 1

let g:fuzzy_ceiling = 50000

autocmd FileType tex setlocal textwidth=78
autocmd BufNewFile,BufRead *.txt setlocal textwidth=78

map <silent> \rb :!ruby %<CR>
map <silent> \cj :!clj %<CR>
map \rd Orequire 'ruby-debug';debugger<ESC>
map <silent> \rt :!ctags -R --exclude=".git\|.svn\|vendor\|db\|pkg" --extra=+f<CR>
map <silent> \nt :NERDTreeToggle<CR>
map <silent> \ff :FuzzyFinderFile<CR>
map <silent> \ft :FuzzyFinderTag<CR>
map <silent> \fb :FuzzyFinderBuffer<CR>
map <silent> \nh :nohls<CR>

if version >= 600
    set foldenable
    set foldmethod=syntax
    set foldlevel=999
endif

if version >= 700
    autocmd BufNewFile,BufRead *.txt setlocal spell spelllang=en_us
    autocmd FileType tex setlocal spell spelllang=en_us
endif
