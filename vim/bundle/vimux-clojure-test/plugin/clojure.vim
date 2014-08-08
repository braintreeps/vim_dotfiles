if exists("g:loaded_vimux_clojure_test") || &cp
  finish
endif
let g:loaded_vimux_clojure_test = 1

if !exists("g:vimux_lein_cmd")
  let g:vimux_lein_cmd = "lein test"
endif

if !exists("g:vimux_lein_clear_console_on_run")
  let g:vimux_lein_clear_console_on_run = 1
endif

command RunAllClojureTests :call s:RunAllClojureTests()

function s:RunAllClojureTests()
  let ns = matchstr(getline(search('^(ns','bnc')), '\v\S+', 3)
  let cmd = g:vimux_lein_cmd . " " . ns

  if g:vimux_lein_clear_console_on_run
    let cmd = "clear && " . cmd
  endif

  call VimuxRunCommand(cmd)
endfunction
