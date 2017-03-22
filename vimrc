" ========= Setup ========

set nocompatible

if &shell == "/usr/bin/sudosh"
  set shell=/bin/bash
endif

" Install vim plugins
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

if filereadable(expand("/etc/vim/vimrc.bundles"))
  source /etc/vim/vimrc.bundles
endif


" ========= Options ========

compiler ruby
syntax on
set hlsearch
set number
set showmatch
set incsearch
set background=dark
set hidden
set backspace=indent,eol,start
set textwidth=0 nosmartindent tabstop=2 shiftwidth=2 softtabstop=2 expandtab
set ruler
set wrap
set dir=/tmp//
set scrolloff=5
set ignorecase
set smartcase
set wildignore+=*.pyc,*.o,*.class,*.lo,.git,vendor/*,node_modules/**,bower_components/**,*/build_gradle/*,*/build_intellij/*,*/build/*,*/cassandra_data/*
set tags+=gems.tags
set backupcopy=yes " Setting backup copy preserves file inodes, which are needed for Docker file mounting

if version >= 703
  set undodir=~/.vim/undodir
  set undofile
  set undoreload=10000 "maximum number lines to save for undo on a buffer reload
endif
set undolevels=1000 "maximum number of changes that can be undone

" Color
colorscheme vibrantink

au FileType diff colorscheme desert
au FileType git colorscheme desert
au BufWinLeave * colorscheme vibrantink

augroup markdown
  au!
  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END

" File Types

autocmd FileType php setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType java setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType cs setlocal tabstop=4 shiftwidth=4 softtabstop=4

autocmd FileType tex setlocal textwidth=78
autocmd BufNewFile,BufRead *.txt setlocal textwidth=78

autocmd FileType ruby runtime ruby_mappings.vim
autocmd FileType python runtime python_mappings.vim

if version >= 700
    autocmd BufNewFile,BufRead *.txt setlocal spell spelllang=en_us
    autocmd FileType tex setlocal spell spelllang=en_us
endif

" Highlight trailing whitespace
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd BufRead,InsertLeave * match ExtraWhitespace /\s\+$/

" Autoremove trailing spaces when saving the buffer
autocmd FileType c,cpp,elixir,eruby,html,java,javascript,php,ruby autocmd BufWritePre <buffer> :%s/\s\+$//e

" Highlight too-long lines
autocmd BufRead,InsertEnter,InsertLeave * 2match LineLengthError /\%126v.*/
highlight LineLengthError ctermbg=black guibg=black
autocmd ColorScheme * highlight LineLengthError ctermbg=black guibg=black

" Set up highlight group & retain through colorscheme changes
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

" Status
set laststatus=2
set statusline=
set statusline+=%<\                       " cut at start
set statusline+=%2*[%n%H%M%R%W]%*\        " buffer number, and flags
set statusline+=%-40f\                    " relative path
set statusline+=%=                        " seperate between right- and left-aligned
set statusline+=%1*%y%*%*\                " file type
set statusline+=%10(L(%l/%L)%)\           " line
set statusline+=%2(C(%v/125)%)\           " column
set statusline+=%P                        " percentage of file

" ========= Plugin Options ========

let g:AckAllFiles = 0
let g:AckCmd = 'ack --type-add ruby=.feature --ignore-dir=tmp 2> /dev/null'

let html_use_css=1
let html_number_lines=0
let html_no_pre=1

let vimclojure#WantNailgun = 0
let vimclojure#HighlightBuiltins = 1
let vimclojure#ParenRainbow = 1

let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1

let g:rubycomplete_buffer_loading = 1


let g:no_html_toolbar = 'yes'

let coffee_no_trailing_space_error = 1

let NERDTreeIgnore=['\.pyc', '\.o', '\.class', '\.lo']
let NERDTreeHijackNetrw = 0

let g:netrw_banner = 0

let g:VimuxUseNearestPane = 1

let g:ctrlp_match_window = 'top,order:ttb,min:1,max:15,results:15'
let g:ctrlp_custom_ignore = {
  \ 'dir': '\(node_modules\|bower_components\|vendor\)$'
  \ }
let g:ctrlp_prompt_mappings = {
  \ 'PrtSelectMove("j")':   ['<c-n>', '<down>'],
  \ 'PrtSelectMove("k")':   ['<c-p>','<c-k>', '<up>'],
  \ 'PrtHistory(-1)':       ['<c-j>'],
  \ 'PrtHistory(1)':        ['<c-k>'],
  \ }

let g:vim_markdown_folding_disabled = 1

let g:go_fmt_command = "goimports"
let g:go_highlight_trailing_whitespace_error = 0

" ========= Shortcuts ========

" NERDTree
map <silent> <LocalLeader>nt :NERDTreeToggle<CR>
map <silent> <LocalLeader>nr :NERDTree<CR>
map <silent> <LocalLeader>nf :NERDTreeFind<CR>

" CtrlP
map <silent> <leader>ff :CtrlP<CR>
map <silent> <leader>fr :CtrlPClearCache<CR>
map <silent> <leader>fb :CtrlPBuffer<CR>

" Ack
map <LocalLeader>aw :Ack '<C-R><C-W>'

" TComment
map <silent> <LocalLeader>cc :TComment<CR>
map <silent> <LocalLeader>uc :TComment<CR>

" Vimux
map <silent> <LocalLeader>rl :wa<CR> :VimuxRunLastCommand<CR>
map <silent> <LocalLeader>vi :wa<CR> :VimuxInspectRunner<CR>
map <silent> <LocalLeader>vk :wa<CR> :VimuxInterruptRunner<CR>
map <silent> <LocalLeader>vx :wa<CR> :VimuxClosePanes<CR>
map <silent> <LocalLeader>vp :VimuxPromptCommand<CR>
vmap <silent> <LocalLeader>vs "vy :call VimuxRunCommand(@v)<CR>
nmap <silent> <LocalLeader>vs vip<LocalLeader>vs<CR>
map <silent> <LocalLeader>ds :call VimuxRunCommand('clear; grep -E "^ *describe[ \(]\|^ *context[ \(]\|^ *it[ \(]" ' . bufname("%"))<CR>

map <silent> <LocalLeader>rt :!ctags -R --exclude=".git\|.svn\|log\|tmp\|db\|pkg" --extra=+f --langmap=Lisp:+.clj<CR>

map <silent> <LocalLeader>cj :!clj %<CR>

map <silent> <LocalLeader>gd :e product_diff.diff<CR>:%!git diff<CR>:setlocal buftype=nowrite<CR>
map <silent> <LocalLeader>pd :e product_diff.diff<CR>:%!svn diff<CR>:setlocal buftype=nowrite<CR>

map <silent> <LocalLeader>nh :nohls<CR>

map <silent> <LocalLeader>bd :bufdo :bd<CR>

cnoremap <Tab> <C-L><C-D>

nnoremap <silent> k gk
nnoremap <silent> j gj
nnoremap <silent> Y y$

map <silent> <LocalLeader>ws :highlight clear ExtraWhitespace<CR>

" Pasting over a selection does not replace the clipboard
xnoremap <expr> p 'pgv"'.v:register.'y'

" ========= Insert Shortcuts ========

imap <C-L> <SPACE>=><SPACE>

" ========= Functions ========

command! SudoW w !sudo tee %

" http://techspeak.plainlystated.com/2009/08/vim-tohtml-customization.html
function! DivHtml(line1, line2)
  exec a:line1.','.a:line2.'TOhtml'
  %g/<style/normal $dgg
  %s/<\/style>\n<\/head>\n//
  %s/body {/.vim_block {/
  %s/<body\(.*\)>\n/<div class="vim_block"\1>/
  %s/<\/body>\n<\/html>/<\/div>
  "%s/\n/<br \/>\r/g

  set nonu
endfunction
command! -range=% DivHtml :call DivHtml(<line1>,<line2>)

function! GitGrepWord()
  cgetexpr system("git grep -n '" . expand("<cword>") . "'")
  cwin
  echo 'Number of matches: ' . len(getqflist())
endfunction
command! -nargs=0 GitGrepWord :call GitGrepWord()
nnoremap <silent> <Leader>gw :GitGrepWord<CR>

function! Trim()
  %s/\s*$//
endfunction
command! -nargs=0 Trim :call Trim()
nnoremap <silent> <Leader>cw :Trim<CR>

function! StartInferiorSlimeServer()
  let g:__InferiorSlimeRunning = 1
  call VimuxRunCommand("inferior-slime")
endfunction
command! -nargs=0 StartInferiorSlimeServer :call StartInferiorSlimeServer()

function! __Edge()
  colorscheme Tomorrow-Night
  au BufWinLeave * colorscheme Tomorrow-Night

  set ttyfast

  map <leader>nf :e%:h<CR>
  map <C-p> :CommandT<CR>

  let g:VimuxOrientation = "h"
  let g:VimuxHeight = "40"
endfunction

function! __HardMode()
  nmap h <nop>
  nmap j <nop>
  nmap k <nop>
  nmap l <nop>
endfunction

" ========= Aliases ========

command! W w

"-------- Local Overrides
""If you have options you'd like to override locally for
"some reason (don't want to store something in a
""publicly-accessible repository, machine-specific settings, etc.),
"you can create a '.local_vimrc' file in your home directory
""(ie: ~/.vimrc_local) and it will be 'sourced' here and override
"any settings in this file.
""
"NOTE: YOU MAY NOT WANT TO ADD ANY LINES BELOW THIS
if filereadable(expand('~/.vimrc_local'))
  source ~/.vimrc_local
end
