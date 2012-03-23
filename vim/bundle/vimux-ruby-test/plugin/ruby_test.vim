if !has("ruby")
  finish
end

command RunAllRubyTests :call RunVimuxRspec(bufname("%"))
command RunRubyFocusedTest :call RunVimuxRspec(bufname("%") . " -l " . line("."))

function RunVimuxRspec(args)
  if executable("rspec")
    let l:spec_command = "rspec"
  else
    let l:spec_command = "spec"
  endif

  let l:command = "clear && " . l:spec_command . " " . a:args
  call RunVimTmuxCommand(l:command)
endfunction
