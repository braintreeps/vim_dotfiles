map <silent> <LocalLeader>rb :wa<CR> :call _RunAll()<CR>
map <silent> <LocalLeader>rc :wa<CR> :RunRubyFocusedContext<CR>
map <silent> <LocalLeader>rf :wa<CR> :call _RunLine()<CR>
map <silent> <LocalLeader>rl :wa<CR> :call _RunLast()<CR>
map <silent> <LocalLeader>rx :wa<CR> :CloseVimTmuxPanes<CR>
map <silent> <LocalLeader>ri :wa<CR> :InspectVimTmuxRunner<CR>
map <silent> <LocalLeader>rs :!ruby -c %<CR>

map <silent> <LocalLeader>sa :wa<CR> :InferiorSlimeSpecAll<CR>
map <silent> <LocalLeader>sr :wa<CR> :InferiorSlimeRestart<CR>

function! _RunLast()
  if exists("g:__InferiorSlimeRunning")
    execute "InferiorSlimeSpecLast"
  else
    execute "VimuxRunLastCommand"
  endif
endfunction

function! _RunAll()
  if exists("g:__InferiorSlimeRunning")
    execute "InferiorSlimeSpecFile"
  else
    execute "RunAllRubyTests"
  endif
endfunction

function! _RunLine()
  if exists("g:__InferiorSlimeRunning")
    execute "InferiorSlimeSpecLine"
  else
    execute "RunRubyFocusedTest"
  endif
endfunction

map <LocalLeader>rd Orequire 'ruby-debug';debugger<ESC>
setlocal isk+=?
