" Vim filetype plugin file
"
" Language:			Groovy
"
" Features:			Runs or compiles Groovy scripts.  Indents code blocks.
" 						Continues comments on adjacent lines.  Provides 
" 						insert-mode abbreviations.  F2 for plugin help.
"
" Installation:	Suggested installation at ~/.vim/ftplugin, or on Windows at 
" 						<Vim install directory>\vimfiles\ftplugin. 
" 						'filetype plugin on' must be specified in .vimrc or _vimrc.
"
" Author:			Jim Ruley <jimruley+vim@gmail.com> 
"
" Date Created:	April 20, 2008
"
" Version:			0.1.2
"
" Modification History:
" 
" 						April 24, 2008: Properly reset modified indent when leaving 
" 						buffer.
"
" 						April 23, 2008: Fixed mappings for F4 and F6, and replaced too 
" 						restrictive cindent.

if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

" Make sure the continuation lines below do not cause problems in
" compatibility mode.
let s:save_cpo = &cpo
set cpo-=C

" For filename completion, prefer .groovy extension over .class extension.
set suffixes+=.class

" Set 'formatoptions' to break comment lines but not other lines,
" and insert the comment leader when hitting <CR> or using "o".
setlocal formatoptions-=t formatoptions+=croql

" Set 'comments' to format dashed lists in comments. Behaves just like C.
setlocal comments& comments^=sO:*\ -,mO:*\ \ ,exO:*/
setlocal commentstring=//%s
 
" Indent 
setlocal smartindent 
setlocal autoindent 

" Script variables
"
" Replace Windows backslashes, that would be swallowed in Cygwin, with slashes
let s:GROOVY_HOME = substitute($GROOVY_HOME, "\\", "/", "g") 
let s:GROOVY_PATH = s:GROOVY_HOME . "/bin/groovy"
let s:GROOVYC_PATH = s:GROOVY_HOME . "/bin/groovyc"
let s:CLASSPATH_PROMPT = "Specify classpath, or hit Enter for none: "
let s:ARG_PROMPT = "Specify arg(s), or hit Enter for none: "
" Buffer variables
let b:classpath = ""
let b:args = ""

" Prompt for classpath/args and run 
if !exists("<SID>RunPrompt()")
	function! <SID>RunPrompt()
		update
		silent cd %:p:h
		if b:classpath == ""
			let b:classpath = input(s:CLASSPATH_PROMPT)
		else
			let changeClasspath = input("Classpath = [". b:classpath . "]  Change? (y or n) ")
			if changeClasspath == "y"
				let b:classpath = input(s:CLASSPATH_PROMPT)
			endif
		endif
		if b:args == ""
			let b:args = input(s:ARG_PROMPT)
		else
			let changeArgs = input("Arg(s) = [". b:args . "]  Change? (y or n) ")
			if changeArgs == "y"
				let b:args = input(s:ARG_PROMPT)
			endif
		endif
		if b:classpath == ""
			if has("win32") || has("win64")
				execute '!"' . s:GROOVY_PATH . '" ' . expand('%') . ' ' . b:args			
			else
				execute "!" . s:GROOVY_PATH . " " . expand("%") . " " . b:args			
			endif
		else
			if has("win32") || has("win64")
				execute '!"' . s:GROOVY_PATH . '" -cp ' . b:classpath  . ' ' . expand('%') . ' ' . b:args			
			else
				execute "!" . s:GROOVY_PATH . " -cp " . b:classpath  . " " . expand("%") . " " . b:args			
			endif
		endif
		silent cd -
	endfunction
endif

" Prompt for classpath and compile
if !exists("<SID>CompilePrompt()")
	function! <SID>CompilePrompt()
		update
		silent cd %:p:h
		if b:classpath == ""
			let b:classpath = input(s:CLASSPATH_PROMPT)
		else
			let changeClasspath = input("Classpath = [". b:classpath . "]  Change? (y or n) ")
			if changeClasspath == "y"
				let b:classpath = input(s:CLASSPATH_PROMPT)
			endif
		endif
		if b:classpath == ""
			if has("win32") || has("win64")
				execute '!"' . s:GROOVYC_PATH . '" ' . expand('%')
			else
				execute "!" . s:GROOVYC_PATH . " " . expand("%")
			endif
		else
			if has("win32") || has("win64")
				execute '!"' . s:GROOVYC_PATH . '" -cp ' . b:classpath  . ' ' . expand('%')
			else
				execute "!" . s:GROOVYC_PATH . " -cp " . b:classpath  . " " . expand("%")
			endif
		endif
		silent cd -
	endfunction
endif
 
" Run with no classpath/args, or with the previously specified values
if !exists("<SID>RunNoPrompt()")
	function! <SID>RunNoPrompt()
		update
		silent cd %:p:h
		if b:classpath == ""
			if has("win32") || has("win64")
				execute '!"' . s:GROOVY_PATH . '" ' . expand("%") . ' ' . b:args			
			else
				execute "!" . s:GROOVY_PATH . " " . expand("%") . " " . b:args			
			endif
		else
			if has("win32") || has("win64")
				execute '!"' . s:GROOVY_PATH . '" -cp ' . b:classpath  . ' ' . expand('%') . ' ' . b:args			
			else
				execute "!" . s:GROOVY_PATH . " -cp " . b:classpath  . " " . expand("%") . " " . b:args			
			endif	
		endif
		silent cd -
	endfunction
endif

" Compile with no classpath, or with the previously specified value
if !exists("<SID>CompileNoPrompt()")
	function! <SID>CompileNoPrompt()
		update
		silent cd %:p:h
		if b:classpath == ""
			if has("win32") || has("win64")
				execute '!"' . s:GROOVYC_PATH . '" ' . expand('%')
			else
				execute "!" . s:GROOVYC_PATH . " " . expand("%")
			endif
		else
			if has("win32") || has("win64")
				execute '!"' . s:GROOVYC_PATH . '" -cp ' . b:classpath  . ' ' . expand('%')
			else
				execute "!" . s:GROOVYC_PATH . " -cp " . b:classpath  . " " . expand("%")
			endif
		endif
		silent cd -
	endfunction
endif

" Display function key descriptions and abbreviations
if !exists("<SID>ShowHelp()")
	function! <SID>ShowHelp()
		echo "_____________________________________________________\n\nF3\tRun with prompt for classpath/arguments\nF4\tRun with no (or previous) classpath/arguments\n\nF5\tCompile with prompt for classpath\nF6\tCompile with no (or previous) classpath\n\nInsert Mode Abbreviations:\n\ncl\tclass declaration\ndcp\tdynamic classpath code\nfl\tfor loop\nfli\tfor loop with index\nifes\tif-else statement\nifs\tif statement\nmm\tmain method\npl\tprintln\nplg\tprintln with GString\npls\tprintln with string\nsf\tstatic final\nsw\tswitch statement\ntc\ttry-catch\ntcf\ttry-catch-finally\nwl\twhile loop\n "	
	endfunction
endif

" Remove the space after an abbreviation
if !exists("<SID>RemoveSpace")
	function! <SID>RemoveSpace()
		let c = nr2char(getchar(0))
		return (c =~ '\s') ? '' : c
	endfunction
endif

if !hasmapto("<SID>ShowHelp()", "n")
	nmap <buffer><unique><silent> <F2> :call <SID>ShowHelp()<CR>
endif
if !hasmapto("<SID>RunPrompt()", "n")
	nmap <buffer><unique><silent> <F3> :call <SID>RunPrompt()<CR>
endif
if !hasmapto("<SID>RunNoPrompt()")
	nmap <buffer><unique><silent> <F4> :call <SID>RunNoPrompt()<CR>
endif
if !hasmapto("<SID>CompilePrompt()")
	nmap <buffer><unique><silent> <F5> :call <SID>CompilePrompt()<CR>
endif
if !hasmapto("<SID>CompileNoPrompt()")
	nmap <buffer><unique><silent> <F6> :call <SID>CompileNoPrompt()<CR>
endif

" Display a help key reminder when first loading Vim (with a Groovy file)
au VimEnter *.groovy echo "F2 for Groovy plugin help"

" Abbreviations
ia <buffer> cl class {<CR>}<Esc>kf{i<C-R>=<SID>RemoveSpace()<CR>
ia <buffer> dcp this.class.classLoader.rootLoader.addURL(new URL('file:///'))<Esc>F'i<C-R>=<SID>RemoveSpace()<CR>
ia <buffer> fl for( in ){<CR>}<Esc>kf(a<C-R>=<SID>RemoveSpace()<CR>
ia <buffer> fli for(int i = 0; i < ; i++){<CR>}<Esc>kf;f;i<C-R>=<SID>RemoveSpace()<CR>
ia <buffer> ifes if(){<CR>}else{<CR>}<Esc>kkf(a<C-R>=<SID>RemoveSpace()<CR>
ia <buffer> ifs if(){<CR>}<Esc>kf(a<C-R>=<SID>RemoveSpace()<CR>
ia <buffer> mm static main(args){<CR>}<Esc>kA<CR><Tab><C-R>=<SID>RemoveSpace()<CR>
ia <buffer> pl println <C-R>=<SID>RemoveSpace()<CR>
ia <buffer> plg println "${}"<Left><Left><C-R>=<SID>RemoveSpace()<CR>
ia <buffer> pls println ''<Left><C-R>=<SID>RemoveSpace()<CR>
ia <buffer> sf static final <C-R>=<SID>RemoveSpace()<CR>
ia <buffer> sw switch(){<CR>}<Esc>kf(a<C-R>=<SID>RemoveSpace()<CR>
ia <buffer> tc try{<CR>}catch(){<CR>}<Esc>kkA<CR><C-R>=<SID>RemoveSpace()<CR>
ia <buffer> tcf try{<CR>}catch(){<CR>}finally{<CR>}<Esc>kkkA<CR><C-R>=<SID>RemoveSpace()<CR>
ia <buffer> wl while(){<CR>}<Esc>kf(a<C-R>=<SID>RemoveSpace()<CR>

" Change the :browse e filter to primarily show Groovy-related files.
if has("gui_win32") && !exists("b:browsefilter") 
    let  b:browsefilter="Groovy Files (*.groovy)\t*.groovy\n" .
		\	"Java Files (*.java)\t*.java\n" .
		\	"GSP Files (*.gsp)\t*.gsp\n" .
		\	"All Files (*.*)\t*.*\n"
endif

" Undo the stuff we changed.
let b:undo_ftplugin = "setlocal suffixes< suffixesadd<" .
		\     " formatoptions< comments< commentstring< path< includeexpr<" .
		\     " smartindent<" .
		\     " autoindent<" .
		\     " | unlet! b:browsefilter"

" Restore the saved compatibility options.
let &cpo = s:save_cpo
