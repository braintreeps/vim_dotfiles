" ========= Setup ========

set nocompatible

if &shell == "/usr/bin/sudosh"
  set shell=/bin/bash
endif

" Install vim plugins
let plugged_path = "~/.vim/plugged"

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
elseif filereadable(expand("~/.vim/vimrc.bundles"))
  source ~/.vim/vimrc.bundles
endif

if filereadable(expand("/etc/vim/vimrc.bundles"))
  source /etc/vim/vimrc.bundles
  let plugged_path = "/etc/vim/plugged"
endif

if !isdirectory(expand(plugged_path))
  autocmd VimEnter * PlugInstall --sync
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
set mouse=
set ttymouse=
set backupcopy=yes " Setting backup copy preserves file inodes, which are needed for Docker file mounting
if v:version > 704 || v:version == 704 && has('patch2201') " signcolumn wasn't added until vim 7.4.2201
  set signcolumn=yes
endif
set complete-=t " Don't use tags for autocomplete
set updatetime=200

if version >= 703
  set undodir=~/.vim/undodir
  set undofile
  set undoreload=10000 "maximum number lines to save for undo on a buffer reload
endif
set undolevels=1000 "maximum number of changes that can be undone

" Color
colorscheme vibrantink

augroup markdown
  au!
  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END
augroup Drakefile
  au!
  au BufNewFile,BufRead Drakefile,drakefile setlocal filetype=ruby
augroup END
augroup Jenkinsfile
  au!
  au BufNewFile,BufRead Jenkinsfile,jenkinsfile setlocal filetype=groovy
augroup END

" File Types

autocmd FileType php setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
autocmd FileType cs setlocal tabstop=4 shiftwidth=4 softtabstop=4

if fnamemodify(getcwd(), ':t') == 'braintree-java'
  autocmd FileType java setlocal tabstop=4 shiftwidth=4 softtabstop=4
else
  autocmd FileType java setlocal tabstop=2 shiftwidth=2 softtabstop=2
endif

autocmd FileType tex setlocal textwidth=78

autocmd FileType ruby runtime ruby_mappings.vim
autocmd FileType python runtime python_mappings.vim
autocmd FileType java runtime java_mappings.vim

" wstrip plugin
" don't highlight trailing whitespace
let g:wstrip_highlight = 0
" strip trailing whitespace on save for any lines modified for the following
" languages
autocmd FileType ruby,java,python,c,cpp,sql,puppet let b:wstrip_auto = 1

if version >= 700
    autocmd BufNewFile,BufRead *.txt setlocal spell spelllang=en_us
    autocmd FileType tex setlocal spell spelllang=en_us
endif

" Run terraform fmt on terraform files
autocmd BufWritePre *.tf call terraform#fmt()

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

" Side Search {{{
let g:side_search_prg = 'ack-grep --word-regexp'
       \. " --heading -C 2 --group"
let g:side_search_splitter = 'vnew'
let g:side_search_split_pct = 0.4

" SideSearch current word and return to original window
nnoremap <Leader>ss :SideSearch <C-r><C-w><CR> | wincmd p

" SS shortcut and return to original window
 command! -complete=file -nargs=+ SS execute 'SideSearch <args>'
" }}}

" Visual * search, modified from: https://git.io/vFGBB
function! s:VSetSearch()
	let temp = @@
	norm! gvy
	let @/ = '\V' . substitute(escape(@@, '\'), '\_s\+', '\\_s\\+', 'g')
	call histadd('/', substitute(@/, '[?/]', '\="\\%d".char2nr(submatch(0))', 'g'))
	let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>/<CR>

let g:ale_enabled = 1                     " Enable linting by default
let g:ale_lint_on_text_changed = 'normal' " Only lint while in normal mode
let g:ale_lint_on_insert_leave = 1        " Automatically lint when leaving insert mode
let g:ale_set_signs = 0                   " Disable signs showing in the gutter to reduce interruptive visuals
let g:ale_linters_explicit = 1            " Only run linters that are explicitly listed below
let g:ale_linters = {}
let g:ale_linters['puppet'] = ['puppetlint']
if filereadable(expand(".rubocop.yml"))
  let g:ale_linters['ruby'] = ['rubocop']
endif

let g:ale_fixers = {}
let g:ale_fix_on_save = 1

let black = system('grep -q black Pipfile')
if v:shell_error == 0
  let g:ale_fixers['python'] = ['black']
  let g:ale_python_black_auto_pipenv = 1
endif

let html_use_css=1
let html_number_lines=0
let html_no_pre=1

let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1

let g:rubycomplete_buffer_loading = 1
let g:ruby_indent_assignment_style = 'variable'

let g:no_html_toolbar = 'yes'

let coffee_no_trailing_space_error = 1

let NERDTreeIgnore=['\.pyc$', '\.o$', '\.class$', '\.lo$', 'tmp']
let NERDTreeHijackNetrw = 0

let g:netrw_banner = 0

let g:VimuxUseNearestPane = 1

let g:rails_projections = {
      \   "script/*.rb": {
      \     "test": "spec/script/{}_spec.rb"
      \   },
      \   "spec/script/*_spec.rb": {
      \     "alternate": "script/{}.rb"
      \   },
      \   "app/lib/*.rb": {
      \     "test": "spec/lib/{}_spec.rb"
      \   }
      \ }

autocmd FileType clojure RainbowParenthesesActivate
autocmd Syntax clojure RainbowParenthesesLoadRound
autocmd Syntax clojure RainbowParenthesesLoadSquare
autocmd Syntax clojure RainbowParenthesesLoadBraces

let g:puppet_align_hashes = 0

let $FZF_DEFAULT_COMMAND = 'find . -name "*" -type f 2>/dev/null                                                         
                            \ | grep -v -E "tmp\/|.gitmodules|.git\/|deps\/|_build\/|node_modules\/|vendor\/"
                            \ | sed "s|^\./||"'                                                                          
let $FZF_DEFAULT_OPTS = '--reverse'
let g:fzf_tags_command = 'ctags -R --exclude=".git\|.svn\|log\|tmp\|db\|pkg" --extra=+f --langmap=Lisp:+.clj'
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

let g:vim_markdown_folding_disabled = 1

let g:go_fmt_command = "goimports"
let g:go_highlight_trailing_whitespace_error = 0

let test#strategy = "vimux"
let test#custom_runners = {}
let test#python#runner = 'pytest'
let nose_test = system('grep -q "nose" requirements.txt')
if v:shell_error == 0
  let test#python#runner = 'nose'
endif

if filereadable(expand('WORKSPACE'))
  let test#custom_runners['java'] = ['bazeltest']
  let test#java#runner = 'bazeltest'
  let g:test#java#bazeltest#test_executable = './bazel test'
  let g:test#java#bazeltest#file_pattern = '.*/test/.*\.java$'
endif

" Remove unused imports for Java
autocmd FileType java autocmd BufWritePre * :UnusedImports

" Language server for Java
if executable('java-language-server')
  autocmd User lsp_setup call lsp#register_server({
    \ 'name': 'java-language-server',
    \ 'cmd': {server_info->['java-language-server', '--quiet']},
    \ 'whitelist': ['java'],
    \ })
  autocmd FileType java nmap <C-e> <plug>(lsp-document-diagnostics)
  autocmd FileType java nmap <C-i> <plug>(lsp-hover)
  autocmd FileType java nmap <C-]> <plug>(lsp-definition)
  autocmd FileType java nmap gr <plug>(lsp-references)
  autocmd FileType java nmap go <plug>(lsp-document-symbol)
  autocmd FileType java nmap gS <plug>(lsp-workspace-symbol)

  let g:asyncomplete_smart_completion = 1
  let g:lsp_insert_text_enabled = 1
endif

" ========= Shortcuts ========

" NERDTree
map <silent> <LocalLeader>nt :NERDTreeToggle<CR>
map <silent> <LocalLeader>nr :NERDTree<CR>
map <silent> <LocalLeader>nf :NERDTreeFind<CR>

" FZF
function! SmartFuzzy()
  let root = split(system('git rev-parse --show-toplevel'), '\n')
  if len(root) == 0 || v:shell_error
    Files
  else
    GFiles -co --exclude-standard -- . ':!:vendor/*'
  endif
endfunction

command! -nargs=* SmartFuzzy :call SmartFuzzy()
map <silent> <leader>ff :SmartFuzzy<CR>
map <silent> <leader>fg :GFiles<CR>
map <silent> <leader>fb :Buffers<CR>
map <silent> <leader>ft :Tags<CR>

map <silent> <C-p> :Files<CR>

" Ack
map <LocalLeader>aw :Ack '<C-R><C-W>'

" TComment
map <silent> <LocalLeader>cc :TComment<CR>
map <silent> <LocalLeader>uc :TComment<CR>

" Vimux
map <silent> <LocalLeader>vl :wa<CR> :VimuxRunLastCommand<CR>
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

" search for trailing whitespace
map <silent> <LocalLeader>ws /\s\+$<CR>

map <silent> <LocalLeader>pp :set paste!<CR>

" YAML
let g:vim_yaml_helper#auto_display_path = 1

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
  ''
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
  nmap <up> <nop>
  nmap <down> <nop>
  nmap <left> <nop>
  nmap <right> <nop>
endfunction

" cleans up the way the default tabline looks
" will show tab numbers next to the basename of the file
" from :help setting-tabline
function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    let s .= '[' . (i + 1) . ']' " set the tab page number (for viewing)
    let s .= '%' . (i + 1) . 'T' " set the tab page number (for mouse clicks)
    let s .= '%{MyTabLabel(' . (i + 1) . ')} ' " the label is made by MyTabLabel()
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'
  return s
endfunction

" with help from http://vim.wikia.com/wiki/Show_tab_number_in_your_tab_line
function! MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let bufnr = buflist[winnr - 1]
  let file = bufname(bufnr)
  let buftype = getbufvar(bufnr, 'buftype')

  if buftype == 'nofile'
    if file =~ '\/.'
      let file = substitute(file, '.*\/\ze.', '', '')
    endif
  else
    let file = fnamemodify(file, ':p:t')
  endif
  if file == ''
    let file = '[No Name]'
  endif
  return file
endfunction

" CTRL-J/K navigation in popups
inoremap <expr> <c-j> (pumvisible()?"\<C-n>":"\<c-j>")
inoremap <expr> <c-k> (pumvisible()?"\<C-p>":"\<c-k>")

set tabline=%!MyTabLine()

" ========= Aliases ========

command! W w


" Autoformat for bazel files
augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
augroup END

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
