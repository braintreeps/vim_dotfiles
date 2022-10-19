function! TestContext()
  wall
  let [_, lnum, cnum, _] = getpos('.')
  RubyBlockSpecParentContext
  TestNearest
  call cursor(lnum, cnum)
endfunction

command! TestContext :call TestContext()

map <silent> <LocalLeader>rc :TestContext<CR>
map <silent> <LocalLeader>rb :wa<CR>:TestFile<CR>
map <silent> <LocalLeader>rf :wa<CR>:TestNearest<CR>
map <silent> <LocalLeader>rl :wa<CR>:TestLast<CR>
map <silent> <LocalLeader>rx :wa<CR>:VimuxCloseRunner<CR>
map <silent> <LocalLeader>ri :wa<CR>:VimuxInspectRunner<CR>
map <silent> <LocalLeader>rs :!ruby -c %<CR>
map <silent> <LocalLeader>AA   :A<CR>
map <silent> <LocalLeader>AV   :AV<CR>
map <silent> <LocalLeader>AS   :AS<CR>

" Restore vim-diff shortcuts
silent! unmap ]c
map <silent> ]C :RubyBlockSpecParentContext<CR>

map <LocalLeader>rd Orequire "pry"; binding.pry<ESC>

" Search for tag
nmap <silent> <LocalLeader>] :Tags '<C-R><C-W> <CR>

setlocal isk+=?
