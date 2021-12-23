let black = system('grep -q black Pipfile')

if v:shell_error == 0
  let g:ale_fixers['python'] = ['black']
  let g:ale_python_black_auto_pipenv = 1
endif
map <silent> <LocalLeader>rb :wa<CR>:TestFile<CR>
map <silent> <LocalLeader>rf :wa<CR>:TestNearest<CR>
map <silent> <LocalLeader>rl :wa<CR>:TestLast<CR>
