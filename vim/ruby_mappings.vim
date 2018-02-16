function! TestContext()
  wall
  let [_, lnum, cnum, _] = getpos('.')
  RubyBlockSpecParentContext
  TestNearest
  call cursor(lnum, cnum)
endfunction

command! TestContext :call TestContext()

map <silent> <LocalLeader>rc :TestContext<CR>
map <silent> <LocalLeader>rb :wa<CR> :TestFile<CR>
map <silent> <LocalLeader>rf :wa<CR> :TestNearest<CR>
map <silent> <LocalLeader>rl :wa<CR> :TestLast<CR>
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

function! _IsInferiorSlimeRunning()
  if system("ps axo command | grep inferior-slime | grep -v grep") == ""
    return 0
  else
    return 1
  end
endfunction

map <LocalLeader>rd Orequire "pry"; binding.pry<ESC>
setlocal isk+=?
