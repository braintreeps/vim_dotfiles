let g:test#csharp#dotnettest#options = '-f netcoreapp2.0'
"let g:test#csharp#dotnettest#options = '-f netstandard1.3'
"let g:test#csharp#dotnettest#options = '-f netcoreapp1.0'

map <silent> <LocalLeader>rb :wa<CR> :TestFile<CR>
map <silent> <LocalLeader>rf :wa<CR> :TestNearest<CR>
map <silent> <LocalLeader>rl :wa<CR> :TestLast<CR>
map <silent> <LocalLeader>rx :wa<CR> :VimuxCloseRunner<CR>
map <silent> <LocalLeader>ri :wa<CR> :VimuxInspectRunner<CR>
