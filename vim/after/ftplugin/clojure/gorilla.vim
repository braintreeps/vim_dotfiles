"-
" Copyright 2008 (c) Meikel Brandmeyer.
" All rights reserved.
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
" THE SOFTWARE.

" Prolog
if !has("ruby")
    finish
endif

try
    if !gatekeeper#Guard("b:clojure_gorilla", "1.0.0")
        finish
    endif
catch /^Vim\%((\a\+)\)\=:E117/
    if exists("b:clojure_gorilla_loaded")
        finish
    endif
    let b:clojure_gorilla_loaded = "1.0.0"
endtry

let s:save_cpo = &cpo
set cpo&vim

" Keyboard Mappings
if !exists("no_plugin_maps") && !exists("no_clojure_gorilla_maps")
    ruby Gorilla.setup_maps()
endif

if exists("gorilla_want_omni") && gorilla_want_omni == 1
    setlocal omnifunc=GorillaOmniTrampoline
endif

" Epilog
let &cpo = s:save_cpo
