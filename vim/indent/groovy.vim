" Vim indent file
" Language:  Groovy
" Maintainer:  Toby Allsopp <toby.allsopp@peace.com> (resigned)
" Last Change:  2005 Mar 28

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

" Indent Groovy anonymous classes correctly.
setlocal cindent cinoptions& cinoptions+=j1

" The "extends" and "implements" lines start off with the wrong indent.
setlocal indentkeys& indentkeys+=0=extends indentkeys+=0=implements

" Don't de-indent things that look like labels (e.g., 'given:',
" 'when:', 'then:', etc., as found in Spock tests)
setlocal cinoptions+=L1

" Set the function to do the work.
setlocal indentexpr=GetGroovyIndent()

let b:undo_indent = "set cin< cino< indentkeys< indentexpr<"

" Only define the function once.
if exists("*GetGroovyIndent")
  finish
endif

function! SkipGroovyBlanksAndComments(startline)
  let lnum = a:startline
  while lnum > 1
    let lnum = prevnonblank(lnum)
    if getline(lnum) =~ '\*/\s*$'
      while getline(lnum) !~ '/\*' && lnum > 1
        let lnum = lnum - 1
      endwhile
      if getline(lnum) =~ '^\s*/\*'
        let lnum = lnum - 1
      else
        break
      endif
    elseif getline(lnum) =~ '^\s*//'
      let lnum = lnum - 1
    else
      break
    endif
  endwhile
  return lnum
endfunction

function GetGroovyIndent()

  " Groovy is just like C; use the built-in C indenting and then correct a few
  " specific cases.
  let theIndent = cindent(v:lnum)

  " If we're in the middle of a comment then just trust cindent
  if getline(v:lnum) =~ '^\s*\*'
    return theIndent
  endif


  " find start of previous line, in case it was a continuation line
  let lnum = SkipGroovyBlanksAndComments(v:lnum - 1)
  let prev = lnum
  while prev > 1
    let next_prev = SkipGroovyBlanksAndComments(prev - 1)
    if getline(next_prev) !~ ',\s*$'
      break
    endif
    let prev = next_prev
  endwhile


  " Try to align "throws" lines for methods and "extends" and "implements" for
  " classes.
  if getline(v:lnum) =~ '^\s*\(extends\|implements\)\>'
        \ && getline(lnum) !~ '^\s*\(extends\|implements\)\>'
    let theIndent = theIndent + &sw
  endif

  " correct for continuation lines of "throws", "implements" and "extends"
  let cont_kw = matchstr(getline(prev),
        \ '^\s*\zs\(throws\|implements\|extends\)\>\ze.*,\s*$')
  if strlen(cont_kw) > 0
    let amount = strlen(cont_kw) + 1
    if getline(lnum) !~ ',\s*$'
      let theIndent = theIndent - (amount + &sw)
      if theIndent < 0
        let theIndent = 0
      endif
    elseif prev == lnum
      let theIndent = theIndent + amount
      if cont_kw ==# 'throws'
        let theIndent = theIndent + &sw
      endif
    endif
  elseif getline(prev) =~ '^\s*\(throws\|implements\|extends\)\>'
        \ && (getline(prev) =~ '{\s*$'
        \  || getline(v:lnum) =~ '^\s*{\s*$')
    let theIndent = theIndent - &sw
  endif

  " When the line starts with a }, try aligning it with the matching {,
  " skipping over "throws", "extends" and "implements" clauses.
  if getline(v:lnum) =~ '^\s*}\s*\(//.*\|/\*.*\)\=$'
    call cursor(v:lnum, 1)
    silent normal %
    let lnum = line('.')
    if lnum < v:lnum
      while lnum > 1
        let next_lnum = SkipGroovyBlanksAndComments(lnum - 1)
        if getline(lnum) !~ '^\s*\(throws\|extends\|implements\)\>'
              \ && getline(next_lnum) !~ ',\s*$'
          break
        endif
        let lnum = prevnonblank(next_lnum)
      endwhile
      return indent(lnum)
    endif
  endif

  " Below a line starting with "}" never indent more.  Needed for a method
  " below a method with an indented "throws" clause.
  let lnum = SkipGroovyBlanksAndComments(v:lnum - 1)
  if getline(lnum) =~ '^\s*}\s*\(//.*\|/\*.*\)\=$' && indent(lnum) < theIndent
    let theIndent = indent(lnum)
  endif

  " Fixed several indent problem
  if theIndent > indent(lnum)
    " if no '{ -> ( if else' , then same indent as previous line
    if getline(lnum) !~ '[\{>\(]\s*$' && getline(lnum) !~ '\s*\(if\|else\)\s*'
      let theIndent = indent(lnum)
    endif

    " if last line end with (
    if getline(lnum) =~ '[\(]\s*$'
      let theIndent = indent(lnum) + &sw
    endif
  endif

  " indent the ')' line with ( line
  if getline(v:lnum) =~ '^\s*)'
    call cursor(v:lnum, 1)
    silent normal %
    let lnum = line('.')
    if lnum < v:lnum
      while lnum > 1
        let next_lnum = SkipGroovyBlanksAndComments(lnum - 1)
        if getline(lnum) !~ '^\s*\(throws\|extends\|implements\)\>'
              \ && getline(next_lnum) !~ ',\s*$'
          break
        endif
        let lnum = prevnonblank(next_lnum)
      endwhile
      return indent(lnum)
    endif
  endif

  return theIndent
endfunction

" vi: sw=2 et
