map <Leader>rb :wa<CR> :RunAllRubyTests<CR>
map <Leader>rf :wa<CR> :RunRubyFocusedTest<CR>
map <Leader>rl :wa<CR> :RunLastVimTmuxCommand<CR>
map <Leader>rx :wa<CR> :CloseVimTmuxWindows<CR>
map <Leader>rp :wa<CR> :PromptVimTmuxCommand<CR>
map <Leader>ri :wa<CR> :InspectVimTmuxRunner<CR>

map <silent> <LocalLeader>rs :!ruby -c %<CR>
map <LocalLeader>rd Orequire 'ruby-debug';debugger<ESC>
setlocal isk+=?
