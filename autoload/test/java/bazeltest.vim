if !exists('g:test#java#bazeltest#executable')
  let g:test#java#bazeltest#executable = 'bazel'
endif

if !exists('g:test#java#bazeltest#file_pattern')
  let g:test#java#bazeltest#file_pattern = g:test#java#maventest#file_pattern
endif

function! test#java#bazeltest#test_file(file) abort
  return a:file =~? g:test#java#bazeltest#file_pattern
    \ && exists('g:test#java#runner')
    \ && g:test#java#runner ==# 'bazeltest'
endfunction

function! test#java#bazeltest#executable() abort
  return g:test#java#bazeltest#executable
endfunction

function! test#java#bazeltest#build_args(args) abort
  return ['test'] + a:args
endfunction

function! test#java#bazeltest#build_position(type, position) abort
  let file = a:position['file']
  let target = s:bazel_target(file)

  if a:type ==# 'nearest'
    let nearest = test#base#nearest_test(a:position, g:test#java#patterns)
    let classname = get(nearest['namespace'], 0, '')
    let testname = get(nearest['test'], 0, '')
    let filter = join([classname] + [testname], '#')
    if !empty(filter)
      return [target, '--test_filter=' . filter]
    endif
  endif

  if a:type ==# 'nearest' || a:type ==# 'file'
    let classname = fnamemodify(file, ':t:r')
    return [target, '--test_filter=' . classname]
  endif

  return [target]
endfunction

function! s:bazel_target(file) abort
  let package = s:bazel_command('query --output=package ' . a:file)
  let label = s:bazel_command('query --output=label ' . a:file)
  let target = s:bazel_command('query ''attr("srcs", "' . label . '", "//' . package . ':*")''')
  return target
endfunction

function! s:bazel_command(args) abort
  let output = system(g:test#java#bazeltest#executable . ' ' . a:args . ' 2> /dev/null')
  return substitute(output, '\n$', '', '')
endfunction
