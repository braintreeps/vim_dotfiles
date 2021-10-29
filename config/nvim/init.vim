    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath = &runtimepath
    source ~/.vim/vimrc

if has('nvim-0.5')
  lua << EOF
  local status, nvim_lsp = pcall(require, 'lspconfig')
  if status then
    local on_attach = require('lsp_on_attach')

    nvim_lsp.gopls.setup{
      on_attach = on_attach;
    }

    nvim_lsp.bashls.setup{
      on_attach = on_attach;
    }
  end

  local status, fzf_lsp = pcall(require, 'fzf_lsp')
  if status then
    fzf_lsp.setup()
  end

  local status, treesitter = pcall(require, 'nvim-treesitter.configs')
  if status then
    treesitter.setup{
      -- List of supported languages can be found here: https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
      ensure_installed = {"bash", "c_sharp", "clojure", "comment", "css", "go", "graphql", "html", "java", "javascript", "json", "kotlin", "lua", "php", "python", "regex", "ruby", "rust", "scala", "toml", "typescript"},
      highlight = {
        enable = true
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
      indent = {
        enable = true
      },
    }

    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
    vim.o.foldlevelstart = 99
  end

  vim.api.nvim_exec([[
    nnoremap <silent> <F5> :lua require('dap').continue()<cr>
    nnoremap <silent> <F10> :lua require('dap').step_over()<cr>
    nnoremap <silent> <F11> :lua require('dap').step_into()<cr>
    nnoremap <silent> <F12> :lua require('dap').step_out()<cr>

    nnoremap <silent> <Leader>bb :lua require('dap').toggle_breakpoint()<cr>
    nnoremap <silent> <Leader>bl :lua require('dap').list_breakpoints()<cr>
    nnoremap <silent> <Leader>bc :lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>
    nnoremap <silent> <Leader>bL :lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>
    nnoremap <silent> <Leader>dr :lua require('dap').repl.open()<cr>
    nnoremap <silent> <Leader>dl :lua require('dap').run_last()<cr>

    command! Continue :lua require('dap').continue()<cr>
    command! StepOver :lua require('dap').step_over()<cr>
    command! StepInto :lua require('dap').step_into()<cr>
    command! StepOut :lua require('dap').step_out()<cr>
  ]], false)
EOF

endif
