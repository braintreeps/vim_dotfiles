autocmd BufEnter * if &ft ==# 'yaml' | :IndentGuidesEnable  | endif
autocmd BufLeave * :IndentGuidesDisable
