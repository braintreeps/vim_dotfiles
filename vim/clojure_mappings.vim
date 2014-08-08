let g:vimux_clojure_test_cmd = "lein test"
map <silent> <LocalLeader>rb :wa<CR> :RunAllClojureTests<CR>
map <silent> <LocalLeader>rf :wa<CR> :RunAllClojureTests<CR>
map <silent> <LocalLeader>rl :wa<CR> :VimuxRunLastCommand<CR>
