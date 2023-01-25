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
if !has('nvim')
  set ttymouse=
endif
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
autocmd FileType cs runtime dotnet_mappings.vim
autocmd FileType javascript runtime javascript_mappings.vim
autocmd FileType python runtime python_mappings.vim
autocmd FileType java runtime java_mappings.vim

" wstrip plugin
" don't highlight trailing whitespace
let g:wstrip_highlight = 0
" strip trailing whitespace on save for any lines modified for the following
" languages
autocmd FileType ruby,java,python,c,cpp,sql,puppet,rust let b:wstrip_auto = 1

autocmd BufNewFile,BufRead *.txt setlocal spell spelllang=en_us
autocmd FileType tex,gitcommit setlocal spell spelllang=en_us

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
let g:ack_default_options = ' --type-add ruby=.feature --ignore-dir=tmp 2>/dev/null'

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
let g:ale_set_signs = 1                   " Enable signs showing in the gutter to reduce interruptive visuals
let g:ale_linters_explicit = 1            " Only run linters that are explicitly listed below
let g:ale_set_highlights = 0              " Disable highlighting as it interferes with readability and accessibility
let g:ale_linters = {}
let g:ale_fixers = {}

if filereadable(expand(".ale_fix_on_save"))
  " add an empty file named .ale_fix_on_save
  " in any repository to enable ale fixers
  " otherwise set the below line in your vimrc_local
  " without the conditional
  let g:ale_fix_on_save = 1
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

let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]

let g:sexp_enable_insert_mode_mappings = 0

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
elseif filereadable('settings.gradle') || executable('./gradlew')
  let test#java#runner = 'gradletest'
  if executable('./gradlew')
    autocmd BufEnter *.java setlocal makeprg=./gradlew\ compileTestJava
    autocmd BufEnter *.scala setlocal makeprg=./gradlew\ compileTestScala
    autocmd BufEnter *.gradle setlocal makeprg=./gradlew\ assemble
  else
    autocmd BufEnter *.java setlocal makeprg=gradle\ compileTestJava
    autocmd BufEnter *.scala setlocal makeprg=gradle\ compileTestScala
    autocmd BufEnter *.gradle setlocal makeprg=gradle\ assemble
  endif
endif

let g:lsp_diagnostics_echo_cursor = 1
let g:asyncomplete_auto_popup = 0

function! s:setup_vim_lsp() abort
  " Define settings and shortcuts for language server-enabled buffers.
  function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> <C-]> <Plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nmap <buffer> <F2> <Plug>(lsp-rename)
    nmap <buffer> <Leader>rn <Plug>(lsp-rename)
    nmap <buffer> <Leader>ca <Plug>(lsp-code-action)
    nmap <buffer> <Leader>ds <Plug>(lsp-document-symbol)
    nmap <buffer> <Leader>ws <Plug>(lsp-workspace-symbol)
    nmap <buffer> <Leader>fd <Plug>(lsp-document-format)
    vmap <buffer> <Leader>fd <Plug>(lsp-document-format)
    " Additional mappings can be seen with :help vim-lsp-mappings
  endfunction

  augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
  augroup END

  if executable('gopls')
    function! s:register_lsp_golang()
      if exists('*lsp#register_command')
        call lsp#register_server({
              \ 'name': 'go-lang',
              \ 'cmd': {server_info->['gopls']},
              \ 'allowlist': ['go'],
              \ })
      else
        echoerr 'Function lsp#register_command() not found, please update your vim-lsp installation'
      endif
    endfunction

    autocmd User lsp_setup call s:register_lsp_golang()
  endif

  " Remove unused imports for Java
  autocmd FileType java autocmd BufWritePre * :UnusedImports

  " Language server for Java
  if executable('java-language-server')
    function! s:register_lsp_java()
      if exists('*lsp#register_command')
        function! s:eclipse_jdt_ls_java_apply_workspaceEdit(context)
          let l:command = get(a:context, 'command', {})
          call lsp#utils#workspace_edit#apply_workspace_edit(l:command['arguments'][0])
        endfunction
        call lsp#register_command('java.apply.workspaceEdit', function('s:eclipse_jdt_ls_java_apply_workspaceEdit'))
      else
        echoerr 'Function lsp#register_command() not found, please update your vim-lsp installation'
      endif

      let l:bundles = ['/home/admin/language-servers/java/extensions/debug.jar']
      call extend(l:bundles, split(glob($HOME."/language-servers/java/extensions/test/extension/server/*.jar"), "\n"))
      call lsp#register_server({
            \ 'name': 'java',
            \ 'cmd': {server_info->['java-language-server', '--heap-max', '8G']},
            \ 'allowlist': ['java'],
            \ 'initialization_options': {
            \     'bundles': l:bundles
            \ }
            \ })
    endfunction

    autocmd User lsp_setup call s:register_lsp_java()
  endif
endfunction

" See config/nvim/init.vim for Neovim-native LSP setup
if !has('nvim-0.5')
  call s:setup_vim_lsp()
endif

" ========= Shortcuts ========

" ALE
map <silent> <leader>an :ALENextWrap<CR>
map <silent> <leader>ap :ALEPreviousWrap<CR>
map <silent> <leader>aj :ALENextWrap<CR>
map <silent> <leader>ak :ALEPreviousWrap<CR>
map <silent> <leader>al :ALELint<CR>
map <silent> <leader>af :ALEFix<CR>
map <silent> <leader>ai :ALEInfo<CR>

" NERDTree
map <silent> <LocalLeader>nt :NERDTreeToggle<CR>
map <silent> <LocalLeader>nr :NERDTree<CR>
map <silent> <LocalLeader>nf :NERDTreeFind<CR>

" EasyAlign
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" Visually select GHE-flavored markdown table, then press tab to align it
au FileType markdown vmap <tab> :EasyAlign*<Bar><Enter>
" In normal mode, press bar (|) to select table and align it
au FileType markdown map <Bar> vip :EasyAlign*<Bar><Enter>

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

" vim-unimpaired

nmap <silent> <C-k> <Plug>unimpairedMoveUp
nmap <silent> <C-j> <Plug>unimpairedMoveDown
nmap <silent> ]h :GitGutterNextHunk<CR>
nmap <silent> [h :GitGutterPrevHunk<CR>
xmap <silent> <C-k> <Plug>unimpairedMoveSelectionUp<esc>gv
xmap <silent> <C-j> <Plug>unimpairedMoveSelectionDown<esc>gv

" GitHubURL
map <silent> <LocalLeader>gh :GitHubURL<CR>

" TComment
map <silent> <LocalLeader>cc :TComment<CR>
map <silent> <LocalLeader>uc :TComment<CR>

" Vimux
map <silent> <LocalLeader>vl :wa<CR>:VimuxRunLastCommand<CR>
map <silent> <LocalLeader>vi :wa<CR>:VimuxInspectRunner<CR>
map <silent> <LocalLeader>vk :wa<CR>:VimuxInterruptRunner<CR>
map <silent> <LocalLeader>vx :wa<CR>:VimuxClosePanes<CR>
map <silent> <LocalLeader>vp :VimuxPromptCommand<CR>
vmap <silent> <LocalLeader>vs "vy :call VimuxRunCommand(@v)<CR>
nmap <silent> <LocalLeader>vs vip<LocalLeader>vs<CR>
map <silent> <LocalLeader>ds :call VimuxRunCommand('clear; grep -E "^ *describe[ \(]\|^ *context[ \(]\|^ *it[ \(]\|^ *specify[ \(]\|^ *example[ \(]" ' . bufname("%"))<CR>

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

" vim-crosspaste map
map <silent> <LocalLeader>qp :call CrossPaste()<CR>

" YAML
let g:vim_yaml_helper#auto_display_path = 1

" Pasting over a selection does not replace the clipboard
xnoremap <expr> p 'pgv"'.v:register.'y'

" ========= Insert Shortcuts ========

imap <C-L> <SPACE>=><SPACE>

" ========= Functions ========

command! SudoW w !sudo tee "%" > /dev/null

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

" https://vim.fandom.com/wiki/Reverse_order_of_lines
command! -bar -range=% ReverseLines <line1>,<line2>g/^/m<line1>-1|nohl

" Initialize glaive if it's installed.
if exists('*glaive#Install')
  call glaive#Install()
endif

" Autoformat settings
augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
augroup END

" Enable shfmt to automatically fix or format shell source code. This feature
" can be disabled by touching .shfmt_disable in a repo's root directory.
function s:EnableShfmt()
  let l:cur_file_dir = expand('%:p:h')
  if strlen(l:cur_file_dir) == 0
    let l:git_dir = getcwd()
  else
    let l:git_dir = l:cur_file_dir
  endif
  let l:git_cmd = 'git -C ' . l:git_dir . ' rev-parse --show-toplevel 2>/dev/null'
  let l:git_root = substitute(system(l:git_cmd), '\n\+$', '', '')
  augroup shells
    autocmd!
    autocmd FileType sh setlocal expandtab
  augroup END
  if v:shell_error == 0 && filereadable(l:git_root . '/.shfmt_disable')
    if has_key(g:ale_fixers, 'sh')
      unlet g:ale_fixers.sh
    endif
  else
    let g:ale_sh_shfmt_options = "-i 2"
    let g:ale_fixers.sh = ['shfmt']
  endif
endfunction

call s:EnableShfmt()

"-------- Local Overrides
""If you have options you'd like to override locally for
"some reason (don't want to store something in a
""publicly-accessible repository, machine-specific settings, etc.),
"you can create a '.local_vimrc' file in your home directory
""(ie: ~/.vimrc_local) and it will be 'sourced' here and override
"any settings in this file.

"-------- System Overrides
"If you have options you'd like to override globally for some reason (don't
"want to store something in a publicly-accessible repository, machine-specific
"settings, etc.), you can create a 'vimrc.global' file in /etc/vim and it will
"be 'sourced' here and override any settings in this file.
""
if filereadable(expand("/etc/vim/vimrc.global"))
  source /etc/vim/vimrc.global
endif

"-------- Local Overrides
"If you have options you'd like to override locally for some reason (don't
"want to store something in a publicly-accessible repository, machine-specific
"settings, etc.), you can create a '.local_vimrc' file in your home directory
"(ie: ~/.vimrc_local) and it will be 'sourced' here and override any settings
"in this file or the above global setting.
"
"NOTE: YOU MAY NOT WANT TO ADD ANY LINES BELOW THIS
if filereadable(expand('~/.vimrc_local'))
  source ~/.vimrc_local
end
