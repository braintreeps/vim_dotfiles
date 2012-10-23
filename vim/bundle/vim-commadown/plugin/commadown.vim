function! CommaDown()
  let last_line = getpos("'>")[1]
  let current_line = line("v")
  let current_line_contents = getline(current_line)
  let stripped_line = substitute(current_line_contents, ",\$", "", "")

  call setline(current_line, stripped_line)

  if current_line != last_line
    call setline(current_line, stripped_line . ",")
  endif
endfunction
