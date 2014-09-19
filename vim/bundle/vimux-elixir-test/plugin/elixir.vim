if exists("g:loaded_vimux_elixir_test") || &cp
  finish
endif
let g:loaded_vimux_elixir_test = 1

command RunAllElixirTests :call s:RunAllElixirTests()
command RunFocusedElixirTests :call s:RunFocusedElixirTests()
command RunCurrentElixirTests :call s:RunCurrentElixirTests()

function s:RunAllElixirTests()
   call VimuxRunCommand("clear && " . "mix test")
endfunction

function s:RunCurrentElixirTests()
   let file_name = @%
   call VimuxRunCommand("clear && " . "mix test " . file_name)
endfunction

function s:RunFocusedElixirTests()
   let line_number = line(".")
   let file_name = @%
   call VimuxRunCommand("clear && mix test " . file_name . ":" . line_number)
endfunction
