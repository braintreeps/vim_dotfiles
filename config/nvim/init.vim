    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath = &runtimepath
    source ~/.vim/vimrc

if has('nvim-0.5')
  lua << EOF
  local status, nvim_lsp = pcall(require, 'lspconfig')
  if status then
    -- Run an LSP command using a Telescope picker if it's available, otherwise use the fallback.
    function lsp_do(picker, fallback)
      if picker == "lsp_code_actions" then
        print('Getting code actions (this may take a while on first use)...')
      end
      vim.schedule(function()
        local status, telescope = pcall(require, 'telescope.builtin')
        if status then
          telescope[picker]{}
        else
          fallback()
        end
      end)
    end

    function lsp_workspace_symbols(query)
      local status, telescope = pcall(require, 'telescope.builtin')
      if status then
        telescope.lsp_workspace_symbols{query=query}
      else
        vim.lsp.buf.workspace_symbol(query)
      end
    end

    local on_attach = function(client, bufnr)
      local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
      local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

      buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

      -- Mappings.
      local opts = { noremap=true, silent=true }

      -- Inspired by https://github.com/neovim/nvim-lspconfig/#keybindings-and-completion,
      -- but with <leader> instead of <space>

      -- Navigation
      buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
      buf_set_keymap('n', 'gd', '<cmd>lua lsp_do("lsp_definitions", vim.lsp.buf.definition)<CR>', opts)
      buf_set_keymap('n', '<Leader>D', '<cmd>lua lsp_do("lsp_type_definitions", vim.lsp.buf.type_definition)<CR>', opts)

      -- Information
      buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
      buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
      buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
      buf_set_keymap('n', 'gr', '<cmd>lua lsp_do("lsp_references", vim.lsp.buf.references)<CR>', opts)
      buf_set_keymap('n', '<Leader>ds', '<cmd>lua lsp_do("lsp_document_symbols", vim.lsp.buf.document_symbol)<CR>', opts)

      -- Diagnostics
      buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
      buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
      buf_set_keymap('n', '<Leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
      buf_set_keymap('n', '<Leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

      -- Refactoring
      buf_set_keymap('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
      buf_set_keymap('n', '<Leader>ca', '<cmd>lua lsp_do("lsp_code_actions", vim.lsp.buf.code_action)<CR>', opts)

      -- Workspaces
      buf_set_keymap('n', '<Leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
      buf_set_keymap('n', '<Leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
      buf_set_keymap('n', '<Leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

      -- Set some keybinds conditional on server capabilities
      if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<Leader>fd", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
      elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("n", "<Leader>fd", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
      end

      -- Set autocommands conditional on server_capabilities
      if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
          hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
          hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
          hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
          augroup lsp_document_highlight
            autocmd!
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
          augroup END
        ]], false)
      end
    end

    local jdtls_bundles = {vim.env.HOME.."/language-servers/java/extensions/debug.jar"};
    vim.list_extend(jdtls_bundles, vim.split(vim.fn.glob(vim.env.HOME.."/language-servers/java/extensions/test/extension/server/*.jar"), "\n"))
    nvim_lsp.jdtls.setup{
      cmd = { "java-language-server", "--heap-max", "8G" };
      init_options = {
        bundles = jdtls_bundles;
      };
      on_attach = on_attach;
    }

    nvim_lsp.gopls.setup{
      on_attach = on_attach;
    }

    nvim_lsp.bashls.setup{
      on_attach = on_attach;
    }
  end

  local status, telescope = pcall(require, 'telescope')
  if status then
    telescope.setup{
      pickers = {
        ['lsp_code_actions'] = {
          timeout = 30000
        }
      }
    }
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

  function notify_file_changed(buffer, change)
    local log = require('vim.lsp.log')
    local filepath = vim.fn.expand('#'..buffer..':p')
    for _,client in pairs(vim.lsp.get_active_clients()) do
      log.info('Notifying LSP server "'..client.name..'" of change to file "'..filepath..'"')
      local result = client.notify('workspace/didChangeWatchedFiles', {
        changes = {{ uri = 'file://'..filepath, type = change }},
      })
      if not result then
        log.warn('File change notification failed!')
      end
    end
  end
EOF

  " LSP servers may not always pick up changes to relevant files, such as when
  " changing a resource file in a Java project. To help ensure that the language
  " server always has recent changes, send a notification to all active servers
  " whenever a file is changed.
  augroup buffer_updates
    au!
    au BufWritePost,FileWritePost * lua notify_file_changed(vim.fn.expand('<abuf>'), 2)
  augroup END

  command! -nargs=1 Symbols :lua lsp_workspace_symbols('<args>')

endif
