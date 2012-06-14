map <silent> <LocalLeader>rb :wa<CR> :RunAllRubyTests<CR>
map <silent> <LocalLeader>rc :wa<CR> :RunRubyFocusedContext<CR>
map <silent> <LocalLeader>rf :wa<CR> :RunRubyFocusedTest<CR>

map <silent> <LocalLeader>rs :!ruby -c %<CR>
map <LocalLeader>rd Orequire 'ruby-debug';debugger<ESC>
setlocal isk+=?
