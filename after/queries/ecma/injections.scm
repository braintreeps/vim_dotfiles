; extends

; [NOTE] You NEED the graphql treesitter parser for this to do anything
; you can either
; - add this to the ensure_installed key in the treesitter plugin configuration
;   and restart neovim
; - run `:TSInstall graphql`
;
; This is adapted and extends https://github.com/nvim-treesitter/nvim-treesitter/blob/master/queries/ecma/injections.scm
; This will match the template string inside of the gql function call, and will
; allow the graphql syntax highlighting via the graphql treesitter parser if it
; is installed for both gql`<query>` and gql(`query`);
(call_expression
  function: (identifier) @_name
  (#eq? @_name "gql")
  arguments: [
    (arguments
      (template_string) @injection.content)
    (template_string) @injection.content
  ]
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#set! injection.language "graphql"))
