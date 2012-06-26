map <silent> <LocalLeader>rb :wa<CR> :RunAllRubyTests<CR>
map <silent> <LocalLeader>rc :wa<CR> :RunRubyFocusedContext<CR>
map <silent> <LocalLeader>rf :wa<CR> :RunRubyFocusedTest<CR>
map <silent> <LocalLeader>rl :wa<CR> :RunLastVimTmuxCommand<CR>
map <silent> <LocalLeader>rx :wa<CR> :CloseVimTmuxPanes<CR>
map <silent> <LocalLeader>ri :wa<CR> :InspectVimTmuxRunner<CR>
map <silent> <LocalLeader>rs :!ruby -c %<CR>

map <silent> <LocalLeader>sa :wa<CR> :InferiorSlimeSpecAll<CR>
map <silent> <LocalLeader>sb :wa<CR> :InferiorSlimeSpecFile<CR>
map <silent> <LocalLeader>sf :wa<CR> :InferiorSlimeSpecLine<CR>
map <silent> <LocalLeader>sl :wa<CR> :InferiorSlimeSpecLast<CR>
map <silent> <LocalLeader>sr :wa<CR> :InferiorSlimeRestart<CR>

map <LocalLeader>rd Orequire 'ruby-debug';debugger<ESC>
setlocal isk+=?
