map <silent> <LocalLeader>ra :wa<CR> :TestSuite<CR>
map <silent> <LocalLeader>rb :wa<CR> :TestFile<CR>
map <silent> <LocalLeader>rf :wa<CR> :TestNearest<CR>
let b:ale_linters['elixir'] = ['mix']
let g:ale_fixers['elixir'] = ['mix_format']
