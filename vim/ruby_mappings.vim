map <silent> <LocalLeader>rb :wa<CR> :call _RunAll()<CR>
map <silent> <LocalLeader>rc :wa<CR> :RunRubyFocusedContext<CR>
map <silent> <LocalLeader>rf :wa<CR> :call _RunLine()<CR>
map <silent> <LocalLeader>rl :wa<CR> :call _RunLast()<CR>
map <silent> <LocalLeader>rx :wa<CR> :VimuxCloseRunner<CR>
map <silent> <LocalLeader>ri :wa<CR> :VimuxInspectRunner<CR>
map <silent> <LocalLeader>rs :!ruby -c %<CR>
map <silent> <LocalLeader>AA   :A<CR>
map <silent> <LocalLeader>AV   :AV<CR>
map <silent> <LocalLeader>AS   :AS<CR>

map <silent> <LocalLeader>sa :wa<CR> :InferiorSlimeSpecAll<CR>
map <silent> <LocalLeader>sr :wa<CR> :InferiorSlimeRestart<CR>

map <LocalLeader>ir :call _BounceInferiorSlime()<CR>

function! _BounceInferiorSlime()
  if _IsInferiorSlimeRunning()
    call VimuxInterruptRunner()
    call VimuxRunCommand("inferior-slime")
  endif
endfunction

function! _RunLast()
  if _IsInferiorSlimeRunning()
    execute "InferiorSlimeSpecLast"
  else
    execute "VimuxRunLastCommand"
  endif
endfunction

function! _RunAll()
  if _IsInferiorSlimeRunning()
    execute "InferiorSlimeSpecFile"
  else
    execute "RunAllRubyTests"
  endif
endfunction

function! _RunLine()
  if _IsInferiorSlimeRunning()
    execute "InferiorSlimeSpecLine"
  else
    execute "RunRubyFocusedTest"
  endif
endfunction

function! _IsInferiorSlimeRunning()
  if system("ps axo command | grep inferior-slime | grep -v grep") == ""
    return 0
  else
    return 1
  end
endfunction

map <LocalLeader>rd Orequire 'ruby-debug';debugger<ESC>
setlocal isk+=?
