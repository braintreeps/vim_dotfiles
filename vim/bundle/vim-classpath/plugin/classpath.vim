" classpath.vim - Set 'path' from the Java class path
" Maintainer:   Tim Pope <http://tpo.pe/>

if exists("g:loaded_classpath") || v:version < 700 || &cp
  finish
endif
let g:loaded_classpath = 1

if &viminfo !~# '!'
  set viminfo^=!
endif

augroup classpath
  autocmd!
  autocmd FileType clojure,groovy,java,scala
        \ if expand('%:p') =~# '^zipfile:' |
        \   let &l:path = getbufvar('#', '&path') |
        \ else |
        \   let &l:path = classpath#detect() |
        \ endif |
        \ command! -buffer -nargs=+ -complete=file Java execute '!'.classpath#java_cmd().' '.<q-args>
augroup END

" vim:set et sw=2:
