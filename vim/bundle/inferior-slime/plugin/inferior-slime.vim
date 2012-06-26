" islime.vim
"
" Description:
"   How to Use
"     :InferiorSlimeRestart
"     :InferiorSlimeSpec
"     :InferiorSlime -H hello hello.txt
"

if exists("g:loaded_islime")
  finish
endif
let g:loaded_islime = 1

if !exists('g:InferiorSlimeCmd')
  let g:InferiorSlimeCmd = '~/bt/inferior-slime/bin/inferior-slime'
endif

if !exists('g:InferiorSlimeOpenWinCmd')
  let g:InferiorSlimeOpenWinCmd = 'cwin'
end

function! s:InferiorSlime(...)
  let args = [g:InferiorSlimeCmd]
  cgetexpr system(join(args, ' '))
  silent exec g:InferiorSlimeOpenWinCmd
  echo 'Inferior Slime finished!'
endfunction

function! s:InferiorSlimeRestart(...)
  let args = [g:InferiorSlimeCmd, 'restart']
  cgetexpr system(join(args, ' '))
  silent exec g:InferiorSlimeOpenWinCmd
endfunction

function! s:InferiorSlimeSpecAll(...)
  let args = [g:InferiorSlimeCmd, 'spec', './spec']
  cgetexpr system(join(args, ' '))
  silent exec g:InferiorSlimeOpenWinCmd
endfunction

function! s:InferiorSlimeSpecFile(...)
  let args = [g:InferiorSlimeCmd, 'spec', expand("%")]
  cgetexpr system(join(args, ' '))
  silent exec g:InferiorSlimeOpenWinCmd
endfunction

function! s:InferiorSlimeSpecLine(...)
  let args = [g:InferiorSlimeCmd, 'spec', expand("%"), '-l', line(".")]
  cgetexpr system(join(args, ' '))
  silent exec g:InferiorSlimeOpenWinCmd
endfunction

function! s:InferiorSlimeSpecLast(...)
  let args = [g:InferiorSlimeCmd, 'spec', 'last']
  cgetexpr system(join(args, ' '))
  silent exec g:InferiorSlimeOpenWinCmd
endfunction

command! -nargs=* -complete=file InferiorSlime :call s:InferiorSlime(<f-args>)
command! -nargs=* -complete=file InferiorSlimeRestart :call s:InferiorSlimeRestart(<f-args>)
command! -nargs=* -complete=file InferiorSlimeSpecAll :call s:InferiorSlimeSpecAll(<f-args>)
command! -nargs=* -complete=file InferiorSlimeSpecFile :call s:InferiorSlimeSpecFile(<f-args>)
command! -nargs=* -complete=file InferiorSlimeSpecLine :call s:InferiorSlimeSpecLine(<f-args>)
command! -nargs=* -complete=file InferiorSlimeSpecLast :call s:InferiorSlimeSpecLast(<f-args>)

" vim: syntax=vim

