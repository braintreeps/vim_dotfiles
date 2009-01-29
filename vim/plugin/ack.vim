" ack.vim
"
" Author: Yuichi Tateno <hotchpotch@NOSPAM@gmail.com>
" Version: 1.0 for Vim 7.1, ack 1.76
" Last Change:  2008 3/8
" Licence: MIT Licence
"
" Description:
"   How to Use
"     :Ack hello
"     :Ack --perl use
"     :Ack -H hello hello.txt
"

if exists("g:loaded_ack")
  finish
endif
let g:loaded_ack = 1

if !exists('g:AckCmd')
  let g:AckCmd = 'ack' " Debian's package ack name is ack-grep.
endif

if !exists('g:AckAllFiles')
  let g:AckAllFiles = 1 " 0 is false.
endif

if !exists('g:AckOpenWinCmd')
  let g:AckOpenWinCmd = 'cwin'
end

function! s:Ack(...)
  let args = [g:AckCmd, '--nocolor', '--nogroup']
  if g:AckAllFiles && len(a:000) == 1
    call add(args, '--all')
  end
  let args += a:000

  cgetexpr system(join(args, ' '))
  silent exec g:AckOpenWinCmd
endfunction

command! -nargs=* -complete=file Ack :call s:Ack(<f-args>)

