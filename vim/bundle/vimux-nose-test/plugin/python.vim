if exists("g:loaded_vimux_nose_test") || &cp
  finish
endif
let g:loaded_vimux_nose_test = 1

command RunAllNoseTests :call s:RunAllNoseTests()
command RunFocusedNoseTests :call s:RunFocusedNoseTests()
command RunCurrentNoseTests :call s:RunCurrentNoseTests()

function! FindVirtualEnv()
   if $VIRTUAL_ENV != ''
      return $VIRTUAL_ENV . "/bin/"
   else
      return ""
   end
endfunction

function s:RunAllNoseTests()
   let virtualenv = FindVirtualEnv()
   call VimuxRunCommand("clear && " . virtualenv . "nosetests")
endfunction

function s:RunCurrentNoseTests()
   let virtualenv = FindVirtualEnv()
   let file_name = @%
   call VimuxRunCommand("clear && " . virtualenv . "nosetests " . file_name)
endfunction

function s:RunFocusedNoseTests()
   let virtualenv = FindVirtualEnv()
   let line_number = line('.')
   let file_name = @%
   call VimuxRunCommand("clear && " . virtualenv . "nosetests " . file_name . " --line " . line_number)
endfunction
