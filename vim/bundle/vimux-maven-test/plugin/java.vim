if exists("g:loaded_vimux_maven_test") || &cp
  finish
endif
let g:loaded_vimux_maven_test = 1

command RunAllMavenTests :call s:RunAllMavenTests()
command RunFocusedMavenTests :call s:RunFocusedMavenTests()
command RunCurrentMavenTests :call s:RunCurrentMavenTests()

function s:ClassName()
  let class_line_num = search("public class", "bn")
  let class_line = getline(class_line_num)
  let class_name = split(class_line, " ")[2]

  return class_name
endfunction

function s:CurrentTestName()
  let test_line_num = search("@Test", "bn") + 1
  let test_line = getline(test_line_num)
  let test_name = substitute(split(test_line, " ")[2], "\(.*$", "", "")

  return test_name
endfunction

function s:RunAllMavenTests()
  call VimuxRunCommand("clear && mvn test")
endfunction

function s:RunCurrentMavenTests()
  call VimuxRunCommand("mvn -Dtest=" . s:ClassName() . " test")
endfunction

function s:RunFocusedMavenTests()
  call VimuxRunCommand("mvn -Dtest=" . s:ClassName() . "#" . s:CurrentTestName() . " test")
endfunction
