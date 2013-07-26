" autoload/classpath.vim
" Maintainer:   Tim Pope <http://tpo.pe>

if exists("g:autoloaded_classpath")
  finish
endif
let g:autoloaded_classpath = 1

if !exists('g:classpath_cache')
  let g:classpath_cache = '~/.cache/vim/classpath'
endif

if !isdirectory(expand(g:classpath_cache))
  call mkdir(expand(g:classpath_cache), 'p')
endif

function! classpath#separator() abort
 return has('win32') ? ';' : ':'
endfunction

function! classpath#file_separator() abort
 return exists('shellslash') && !&shellslash ? '\' : '/'
endfunction

function! classpath#split(cp) abort
  return split(a:cp, classpath#separator())
endfunction

function! classpath#to_vim(cp) abort
  let path = []
  for elem in classpath#split(a:cp)
    let path += [elem ==# '.' ? '' : elem]
  endfor
  if a:cp =~# '\(^\|:\)\.$'
    let path += ['']
  endif
  return join(map(path, 'escape(v:val, ", ")'), ',')
endfunction

function! classpath#from_vim(path) abort
  if a:path =~# '^,\=$'
    return '.'
  endif
  let path = []
  for elem in split(substitute(a:path, ',$', '', ''), ',')
    if elem ==# ''
      let path += ['.']
    else
      let path += split(glob(substitute(elem, '\\\ze[\\ ,]', '', 'g'), 1), "\n")
    endif
  endfor
  return join(path, classpath#separator())
endfunction

function! classpath#detect(...) abort
  let sep = classpath#file_separator()

  let buffer = a:0 ? a:1 : '%'
  let default = $CLASSPATH ==# '' ? ',' : classpath#to_vim($CLASSPATH)
  let root = getbufvar(buffer, 'java_root')
  if root ==# ''
    let root = simplify(fnamemodify(bufname(buffer), ':p:s?[\/]$??'))
  endif

  if !isdirectory(fnamemodify(root, ':h'))
    return default
  endif

  let previous = ""
  while root !=# previous
    if filereadable(root . '/project.clj') && join(readfile(root . '/project.clj', '', 50), "\n") =~# '(\s*defproject'
      let file = 'project.clj'
      let cmd = 'lein classpath'
      let pattern = "[^\n]*\\ze\n*$"
      let default = join(map(['test', 'src', 'dev-resources', 'resources', 'target'.sep.'classes'], 'escape(root . sep . v:val, ", ")'), ',')
      let base = ''
      break
    endif
    if filereadable(root . '/pom.xml')
      let file = 'pom.xml'
      let cmd = 'mvn dependency:build-classpath'
      let pattern = '\%(^\|\n\)\zs[^[].\{-\}\ze\n'
      let base = escape(root.sep.'src'.sep.'*'.sep.'*', ', ') . ','
      let default = base . default
      break
    endif
    let previous = root
    let root = fnamemodify(root, ':h')
  endwhile

  if !exists('file')
    if a:0 > 1 && a:2 ==# 'keep'
      return ''
    else
      return default
    endif
  endif

  if exists('g:CLASSPATH_CACHE') && (type(g:CLASSPATH_CACHE) != type({}) || empty(g:CLASSPATH_CACHE))
    unlet! g:CLASSPATH_CACHE
  endif

  let cache = expand(g:classpath_cache . '/') . substitute(root, '[:\/]', '%', 'g')
  let disk = getftime(root . sep . file)

  if exists('g:CLASSPATH_CACHE') && has_key(g:CLASSPATH_CACHE, root)
    let [when, last, path] = split(g:CLASSPATH_CACHE[root], "\t")
    call remove(g:CLASSPATH_CACHE, root)
    if last ==# disk
      call writefile([path], cache)
      return path
    endif
  endif

  if getftime(cache) >= disk
    return join(readfile(cache), classpath#separator())
  else
    try
      if &verbose
        echomsg 'Determining class path with '.cmd.' ...'
      endif
      let cd = exists('*haslocaldir') && haslocaldir() ? 'lcd ' : 'cd '
      let dir = getcwd()
      try
        execute cd . fnameescape(root)
        let out = system(cmd)
      finally
        execute cd . fnameescape(dir)
      endtry
    catch /^Vim:Interrupt/
      return default
    endtry
    let match = matchstr(out, pattern)
    if !v:shell_error && exists('out') && out !=# ''
      let path = base . classpath#to_vim(match)
      call writefile([path], cache)
      return path
    else
      echohl WarningMSG
      echomsg "Couldn't determine class path."
      echohl NONE
      echo out
      return default
    endif
  endif
endfunction

function! classpath#java_cmd(...)
  let path = classpath#from_vim(a:0 ? a:1 : &path)
  return (exists('$JAVA_CMD') ? $JAVA_CMD : 'java') . ' -cp '.shellescape(path)
endfunction

" vim:set et sw=2:
