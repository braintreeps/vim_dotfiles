let s:context_start_pattern =
    \ '\C^\s*#\@!\s*\%(RSpec\.\)\=\zs' .
    \ '\<\%(module\|class\|if\|for\|while\|until\|case\|unless\|begin\|def' .
    \ '\|\%(public\|protected\|private\)\=\s*def\):\@!\>' .
    \ '\|\%(^\|[^.:@$]\)\@<=\<do:\@!\>'
let s:context_end_pattern = '\%(^\|[^.:@$]\)\@<=\<end:\@!\>'
let s:context_test_pattern =
    \ '\C^\s*#\@!\s*\%(RSpec\.\)\=\zs' .
    \ '\<\%(describe\|context\|shared_examples\|shared_context\)\>'

function! TestContext()
  wall
  normal 0
  let [_, lnum, cnum, _] = getpos('.')
  if getline('.') !~ s:context_test_pattern
    let prev_line = line('.')
    while line('.') != 1
      call searchpair(s:context_start_pattern, '', s:context_end_pattern, 'Wb')
      if getline('.') =~ s:context_test_pattern || line('.') == prev_line
        break
      endif
      let prev_line = line('.')
    endwhile
  endif
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
