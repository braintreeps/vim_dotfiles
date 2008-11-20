" Vim syntax file
" Language:	   Clojure
" Last Change: 2008-08-31
" Maintainer:  Toralf Wittner <toralf.wittner@gmail.com>
"              modified by Meikel Brandmeyer <mb@kotka.de>
" URL:         http://kotka.de/projects/clojure/vimclojure.html

if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

if exists("g:clj_highlight_builtins") && g:clj_highlight_builtins != 0
	" Boolean
	syn keyword clojureBoolean   true false

	" Predicates and Tests
	syn keyword clojureFunc      = not= not nil? false? true? complement
	syn keyword clojureFunc      identical? string? symbol? map? seq? vector?
	syn keyword clojureFunc      keyword? special-symbol? var?
	syn keyword clojureMacro     and or

	" Conditionals
	syn keyword clojureCond      if if-let when when-not when-let when-first cond
	syn keyword clojureException try catch finally throw

	" Functionals
	syn keyword clojureFunc      apply partial comp constantly identity comparator
	syn keyword clojureMacro     fn

	" Regular Expressions
	syn keyword clojureFunc      re-matcher re-find re-matches re-groups re-seq re-pattern

	" Define
	syn keyword clojureDefine    def def- defn defn- defmacro let

	" Other Functions
	syn keyword clojureFunc      str time pr prn print println pr-str prn-str
	syn keyword clojureFunc      print-str println-str newline macroexpand
	syn keyword clojureFunc      macroexpand-1 monitor-enter monitor-exit doc
	syn keyword clojureFunc      eval find-doc file-seq flush hash load load-file
	syn keyword clojureFunc      print-doc read read-line scan slurp subs sync
	syn keyword clojureFunc      test format printf load-resources loaded-libs
	syn keyword clojureFunc      use require
	syn keyword clojureMacro     -> assert with-out-str with-in-str with-open
	syn keyword clojureMacro     locking do quote var loop destructure
	syn keyword clojureRepeat    recur
	syn keyword clojureVariable  *in* *out* *command-line-args* *print-meta* *print-readably*

	" Nil
	syn keyword clojureConstant  nil

	" Number Functions
	syn keyword clojureFunc      + - * / < <= == >= > dec inc min max neg? pos?
	syn keyword clojureFunc      quot rem zero? rand rand-int

	" Bit Functions
	syn keyword clojureFunc      bit-and bit-or bit-xor bit-not bit-shift-left bit-shift-right

	" Symbols
	syn keyword clojureFunc      symbol keyword gensym

	" Collections
	syn keyword clojureFunc      count conj seq first rest ffirst frest rfirst
	syn keyword clojureFunc      rrest second every? not-every? some not-any?
	syn keyword clojureFunc      concat reverse cycle interleave interpose
	syn keyword clojureFunc      split-at split-with take take-nth take-while
	syn keyword clojureFunc      drop drop-while repeat replicate iterate range
	syn keyword clojureFunc      into distinct sort sort-by zipmap fnseq lazy-cons
	syn keyword clojureFunc      lazy-cat line-seq butlast last nth nthrest
	syn keyword clojureFunc      repeatedly tree-seq enumeration-seq iterator-seq
	syn keyword clojureRepeat    map mapcat reduce filter for doseq dorun doall dotimes

	" Lists
	syn keyword clojureFunc      list list* cons peek pop

	" Vectors
	syn keyword clojureFunc      vec vector peek pop rseq subvec

	" Maps
	syn keyword clojureFunc      array-map hash-map sorted-map sorted-map-by
	syn keyword clojureFunc      assoc assoc-in dissoc get get-in contains? find
	syn keyword clojureFunc      select-keys update-in key val keys vals merge
	syn keyword clojureFunc      merge-with max-key min-key

	" Struct-Maps
	syn keyword clojureFunc      create-struct struct-map struct accessor
	syn keyword clojureDefine    defstruct

	" Sets
	syn keyword clojureFunc      hash-set sorted-set set disj union difference
	syn keyword clojureFunc      intersection select index rename join
	syn keyword clojureFunc      map-invert project

	" Multimethods
	syn keyword clojureFunc      remove-method
	syn keyword clojureDefine    defmulti defmethod

	" Metadata
	syn keyword clojureFunc      meta with-meta

	" Namespaces
	syn keyword clojureFunc      in-ns clojure/in-ns refer clojure/refer create-ns
	syn keyword clojureFunc      find-ns all-ns remove-ns import ns-name ns-map
	syn keyword clojureFunc      ns-interns ns-publics ns-imports ns-refers
	syn keyword clojureFunc      ns-resolve resolve ns-unmap name namespace
	syn keyword clojureFunc      require use
	syn keyword clojureMacro     ns clojure/ns
	syn keyword clojureVariable  *ns*

	" Vars and Environment
	syn keyword clojureFunc      set! find-var var-get var-set
	syn keyword clojureMacro     binding with-local-vars

	" Refs and Transactions
	syn keyword clojureFunc      ref deref ensure alter ref-set commute
	syn keyword clojureMacro     dosync

	" Agents
	syn keyword clojureFunc      agent send send-off agent-errors
	syn keyword clojureFunc      clear-agent-errors await await-for
	syn keyword clojureVariable  *agent*

	" Java Interaction
	syn keyword clojureFunc      instance? bean alength aget aset aset-boolean
	syn keyword clojureFunc      aset-byte aset-char aset-double aset-float
	syn keyword clojureFunc      aset-int aset-long aset-short areduce make-array
	syn keyword clojureFunc      to-array to-array-2d into-array int long float
	syn keyword clojureFunc      double char boolean short byte parse add-classpath
	syn keyword clojureFunc      cast class get-proxy-class proxy-mappings update-proxy
	syn keyword clojureMacro     .. doto memfn proxy
	syn keyword clojureSpecial   . new
	syn keyword clojureVariable  *warn-on-reflection* *proxy-classes* this

	" Zip
	syn keyword clojureFunc      append-child branch? children up down edit end?
	syn keyword clojureFunc      insert-child insert-left insert-right left lefts
	syn keyword clojureFunc      right rights make-node next node path remove
	syn keyword clojureFunc      replace root seq-zip vector-zip xml-zip zipper
endif

syn cluster clojureAtomCluster   contains=clojureFunc,clojureMacro,clojureCond,clojureDefine,clojureRepeat,clojureConstant,clojureVariable,clojureSpecial,clojureKeyword,clojureString,clojureCharacter,clojureNumber,clojureRational,clojureFloat,clojureBoolean,clojureQuote,clojureUnquote,clojureDispatch,clojurePattern
syn cluster clojureTopCluster    contains=@clojureAtomCluster,clojureComment,clojureSexp,clojureAnonFn,clojureVector,clojureMap,clojureSet

syn keyword clojureTodo contained FIXME XXX
syn match   clojureComment contains=clojureTodo ";.*$"

syn match   clojureKeyword ":\a[a-zA-Z0-9?!\-_+*\./=<>]*"

syn region  clojureString start=/"/ end=/"/ skip=/\\"/

syn match   clojureCharacter "\\."
syn match   clojureCharacter "\\[0-7]\{3\}"
syn match   clojureCharacter "\\u[0-9]\{4\}"
syn match   clojureCharacter "\\space"
syn match   clojureCharacter "\\tab"
syn match   clojureCharacter "\\newline"
syn match   clojureCharacter "\\backspace"
syn match   clojureCharacter "\\formfeed"

syn match   clojureNumber "\<-\?[0-9]\+\>"
syn match   clojureRational "\<-\?[0-9]\+/[0-9]\+\>"
syn match   clojureFloat "\<-\?[0-9]\+\.[0-9]\+\([eE][-+]\=[0-9]\+\)\=\>"

syn match   clojureQuote "\('\|`\)"
syn match   clojureUnquote "\(\~@\|\~\)"
syn match   clojureDispatch "\(#^\|#'\)"

syn match   clojureAnonArg contained "%\(\d\|&\)\?"
syn match   clojureVarArg contained "&"

if exists("g:clj_paren_rainbow") && g:clj_paren_rainbow != 0
	syn region clojureSexpLevel0 matchgroup=clojureParen0 start="(" matchgroup=clojureParen0 end=")"           contains=@clojureTopCluster,clojureSexpLevel1
	syn region clojureSexpLevel1 matchgroup=clojureParen1 start="(" matchgroup=clojureParen1 end=")" contained contains=@clojureTopCluster,clojureSexpLevel2
	syn region clojureSexpLevel2 matchgroup=clojureParen2 start="(" matchgroup=clojureParen2 end=")" contained contains=@clojureTopCluster,clojureSexpLevel3
	syn region clojureSexpLevel3 matchgroup=clojureParen3 start="(" matchgroup=clojureParen3 end=")" contained contains=@clojureTopCluster,clojureSexpLevel4
	syn region clojureSexpLevel4 matchgroup=clojureParen4 start="(" matchgroup=clojureParen4 end=")" contained contains=@clojureTopCluster,clojureSexpLevel5
	syn region clojureSexpLevel5 matchgroup=clojureParen5 start="(" matchgroup=clojureParen5 end=")" contained contains=@clojureTopCluster,clojureSexpLevel6
	syn region clojureSexpLevel6 matchgroup=clojureParen6 start="(" matchgroup=clojureParen6 end=")" contained contains=@clojureTopCluster,clojureSexpLevel7
	syn region clojureSexpLevel7 matchgroup=clojureParen7 start="(" matchgroup=clojureParen7 end=")" contained contains=@clojureTopCluster,clojureSexpLevel8
	syn region clojureSexpLevel8 matchgroup=clojureParen8 start="(" matchgroup=clojureParen8 end=")" contained contains=@clojureTopCluster,clojureSexpLevel9
	syn region clojureSexpLevel9 matchgroup=clojureParen9 start="(" matchgroup=clojureParen9 end=")" contained contains=@clojureTopCluster,clojureSexpLevel0
else
	syn region clojureSexp       matchgroup=clojureParen0 start="(" matchgroup=clojureParen0 end=")"           contains=@clojureTopCluster
endif

syn region  clojureAnonFn  matchgroup=clojureParen0 start="#(" matchgroup=clojureParen0 end=")"  contains=@clojureTopCluster,clojureAnonArg,clojureSexpLevel0
syn region  clojureVector  matchgroup=clojureParen0 start="\[" matchgroup=clojureParen0 end="\]" contains=@clojureTopCluster,clojureVarArg,clojureSexpLevel0
syn region  clojureMap     matchgroup=clojureParen0 start="{"  matchgroup=clojureParen0 end="}"  contains=@clojureTopCluster,clojureSexpLevel0
syn region  clojureSet     matchgroup=clojureParen0 start="#{" matchgroup=clojureParen0 end="}"  contains=@clojureTopCluster,clojureSexpLevel0
syn region  clojurePattern                          start=/#"/                          end=/"/  skip=/\\"/

syn region  clojureCommentSexp                          start="("                                       end=")" transparent contained contains=clojureCommentSexp
syn region  clojureComment     matchgroup=clojureParen0 start="(comment"rs=s+1 matchgroup=clojureParen0 end=")"                       contains=clojureCommentSexp

syn sync match matchPlace grouphere NONE "^[^ \t]"

if version >= 600
	command -nargs=+ HiLink highlight default link <args>
else
	command -nargs=+ HiLink highlight         link <args>
endif

HiLink clojureConstant  Constant
HiLink clojureBoolean   Boolean
HiLink clojureCharacter Character
HiLink clojureKeyword   Operator
HiLink clojureNumber    Number
HiLink clojureRational  Number
HiLink clojureFloat     Float
HiLink clojureString    String
HiLink clojurePattern   Constant

HiLink clojureVariable  Identifier
HiLink clojureCond      Conditional
HiLink clojureDefine    Define
HiLink clojureException Exception
HiLink clojureFunc      Function
HiLink clojureMacro     Macro
HiLink clojureRepeat    Repeat

HiLink clojureQuote     Special
HiLink clojureUnquote   Special
HiLink clojureDispatch  Special
HiLink clojureAnonArg   Special
HiLink clojureVarArg    Special
HiLink clojureSpecial   Special

HiLink clojureComment   Comment
HiLink clojureTodo      Todo

HiLink clojureParen0    Delimiter

if exists("g:clj_paren_rainbow") && g:clj_paren_rainbow != 0
	if &background == "dark"
		highlight default clojureParen1 ctermfg=yellow      guifg=orange1
		highlight default clojureParen2 ctermfg=green       guifg=yellow1
		highlight default clojureParen3 ctermfg=cyan        guifg=greenyellow
		highlight default clojureParen4 ctermfg=magenta     guifg=green1
		highlight default clojureParen5 ctermfg=red         guifg=springgreen1
		highlight default clojureParen6 ctermfg=yellow      guifg=cyan1
		highlight default clojureParen7 ctermfg=green       guifg=slateblue1
		highlight default clojureParen8 ctermfg=cyan        guifg=magenta1
		highlight default clojureParen9 ctermfg=magenta     guifg=purple1
	else
		highlight default clojureParen1 ctermfg=darkyellow  guifg=orangered3
		highlight default clojureParen2 ctermfg=darkgreen   guifg=orange2
		highlight default clojureParen3 ctermfg=blue        guifg=yellow3
		highlight default clojureParen4 ctermfg=darkmagenta guifg=olivedrab4
		highlight default clojureParen5 ctermfg=red         guifg=green4
		highlight default clojureParen6 ctermfg=darkyellow  guifg=paleturquoise3
		highlight default clojureParen7 ctermfg=darkgreen   guifg=deepskyblue4
		highlight default clojureParen8 ctermfg=blue        guifg=darkslateblue
		highlight default clojureParen9 ctermfg=darkmagenta guifg=darkviolet
	endif
endif

delcommand HiLink

let b:current_syntax = "clojure"
