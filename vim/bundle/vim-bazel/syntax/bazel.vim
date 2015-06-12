if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Include Python syntax.
runtime! syntax/python.vim

syntax keyword bazelRule contained
  \ cc_binary
  \ cc_library
  \ cc_test
  \ java_binary
  \ java_import
  \ java_library
  \ java_test
  \ java_plugin
  \ ios_application
  \ ios_device
  \ ios_extension
  \ ios_extension_binary
  \ objc_binary
  \ objc_bundle
  \ objc_bundle_library
  \ objc_framework
  \ objc_import
  \ objc_library
  \ objc_proto_library
  \ ios_test
  \ objc_xcodeproj
  \ py_binary
  \ py_library
  \ sh_binary
  \ sh_library
  \ sh_test
  \ action_listener
  \ extra_action
  \ filegroup
  \ genquery
  \ test_suite
  \ bind
  \ config_setting
  \ genrule
  \ http_archive
  \ http_jar
  \ local_repository
  \ maven_jar
  \ new_http_archive
  \ new_local_repository

syntax match pythonArgName "\w\+\(\s*=\)\@=" contains=bazelAttribute transparent
syntax match pythonCall    "\w\+\(\s*(\)\@=" contains=bazelRule transparent

highlight def link bazelRule      Statement
highlight def link bazelAttribute Identifier

let b:current_syntax = "bazel"
