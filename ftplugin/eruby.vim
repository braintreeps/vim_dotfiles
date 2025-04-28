autocmd BufEnter * if &ft ==# 'eruby' | :IndentGuidesEnable  | endif
autocmd BufLeave * :IndentGuidesDisable
