local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local LazyFileEvents = { "BufReadPost", "BufNewFile", "BufWritePre" }

require("lazy").setup({
  { 'arthurxavierx/vim-caser', event = LazyFileEvents }, -- Change word casing with vim motion
  {
    "lewis6991/gitsigns.nvim", -- Show diffs and more!
    event = LazyFileEvents,
    opts = {},
    keys = {
      { "<Leader>bl", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "[b]lame [l]ine" },
    },
  },
  -- vim-codefmt doesn't seem to work with Lazy
  -- TODO can this be deprecated in favor of another formatting tool?
--  {
--	  'google/vim-codefmt',
--	  dependencies = { 'google/vim-glaive', 'google/vim-maktaba' },
--  },
  -- 'dewyze/vim-ruby-block-helpers', -- TODO can this be substituted with something that `mini.nvim` offers, or Treesitter text objects?
  {
    'janko-m/vim-test',
    dependencies = {
      {
        'benmills/vimux',
        dependencies = {
          'jgdavey/vim-turbux',
          'samguyjones/vim-crosspaste',
        },
        keys = {
          { "<Leader>rx", "<cmd>wa<CR> <cmd>VimuxCloseRunner<CR>" },
          { "<Leader>ri", "<cmd>wa<CR> <cmd>VimuxInspectRunner<CR>" },
          { "<Leader>vs", '"vy :call VimuxRunCommand(@v)<CR>', mode = "v" },
          { "<Leader>vs", 'vip "vy :call VimuxRunCommand(@v)<CR>' },
        },
        init = function()
          vim.g["test#strategy"] = "vimux"
        end,
      },
    },
    keys = {
      { "<Leader>rb", "<cmd>wa<CR> <cmd>TestFile<CR>" },
      { "<Leader>rf", "<cmd>wa<CR> <cmd>TestNearest<CR>" },
      { "<Leader>rl", "<cmd>wa<CR> <cmd>TestLast<CR>" },
    },
  },
  { 'junegunn/vim-easy-align', event = LazyFileEvents }, -- Used to align text; this should be driven by an LSP
  { "kshenoy/vim-signature", event = LazyFileEvents }, -- Used to add/remove/go-to marks
  { 'kana/vim-textobj-user', lazy = true }, -- used to create custom text objects; TODO mark for deletion
  { 'mattn/emmet-vim', lazy = true }, -- used for a expanding abbreviations/adding tags to HTML; TODO mark for deletion
  { 'mileszs/ack.vim', lazy = true }, -- used for searching. We use fzf + rg; TODO mark for deletion
  { 'pgr0ss/vim-github-url', event = LazyFileEvents },
  {
    'hrsh7th/nvim-cmp',
    event = { "InsertEnter" },
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        build = (function()
          -- Build Step is needed for regex support in snippets
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        dependencies = {
          {
            "rafamadriz/friendly-snippets",
            config = function()
              require("luasnip.loaders.from_vscode").lazy_load()
            end,
          },
        },
      },
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-emoji',
      'andersevenrud/cmp-tmux',
      'davidsierradz/cmp-conventionalcommits',
      'onsails/lspkind-nvim',
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      local defaults = require("cmp.config.default")()

      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({ { name = "conventionalcommits" } })
      })

      cmp.setup({
        sorting = defaults.sorting,
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        formatting = {
          format = lspkind.cmp_format({ mode = "symbol_text" })
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<C-CR>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "path" },
        }, {
          { name = "emoji" },
          { name = "tmux" },
        })
      })
    end,
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
      {
        's1n7ax/nvim-window-picker',
        version = '2.*',
        config = function()
            require 'window-picker'.setup({
                filter_rules = {
                    include_current_win = false,
                    autoselect_one = true,
                    -- filter using buffer options
                    bo = {
                        -- if the file type is one of following, the window will be ignored
                        filetype = { 'neo-tree', "neo-tree-popup", "notify" },
                        -- if the buffer type is one of following, the window will be ignored
                        buftype = { 'terminal', "quickfix" },
                    },
            },
        })
        end,
      },
    },
    keys = {
      { '<Leader>nt', '<cmd>Neotree toggle<CR>' },
      { '<Leader>nf', '<cmd>Neotree reveal<CR>' },
    },
    opts = {
      sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols' },
      open_files_do_not_replace_types = { 'terminal', 'qf', 'Outline' },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          hide_hidden = false,
          hide_dotfiles = false,
        },
      },
      window = {
        mappings = {
          ['<space>'] = 'none',
          ['Y'] = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg('+', path, 'c')
          end,
          ["S"] = "split_with_window_picker",
          ["s"] = "vsplit_with_window_picker",
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
      },
    },
  },
  { 'tfnico/vim-gradle', event = LazyFileEvents },
  {
    'numToStr/Comment.nvim',
    event = LazyFileEvents,
    opts = {},
  },

  'tpope/vim-projectionist',
  { 'tpope/vim-fugitive', event = LazyFileEvents },
  { 'tpope/vim-ragtag', event = LazyFileEvents },
  {
    'tpope/vim-rake',
    keys = {
      { "<Leader>AA", "<cmd>A<CR>" },
      { "<Leader>AV", "<cmd>AV<CR>" },
      { "<Leader>AS", "<cmd>AS<CR>" },
    },
    init = function()
      vim.g["rails_projections"] = {
        ["script/*.rb"] = {
          test = "spec/script/{}_spec.rb",
        },
        ["spec/script/*_spec.rb"] = {
          alternate = "script/{}.rb"
        },
        ["app/lib/*.rb"] = {
          test = "spec/lib/{}_spec.rb"
        },
        ["lib/tasks/*.rake"] = {
          test = "spec/lib/tasks/{}_rake_spec.rb",
        },
      }
    end,
  },
  'tpope/vim-repeat',
  { 'tpope/vim-rhubarb', events = LazyFileEvents },
  'tpope/vim-surround',
  'tpope/vim-unimpaired',
  'tpope/vim-vinegar',
  { 'vim-scripts/Align', lazy = true },
  { 'vim-scripts/VimClojure', lazy = true },
  { 'vim-scripts/groovyindent-unix', lazy = true },
  { 'vim-scripts/mako.vim', lazy = true },
  { 'vim-scripts/matchit.zip', lazy = true },
  { 'tweekmonster/wstrip.vim', event = { "BufWritePre" } },
  -- TODO Removable plugins??
  { 'tpope/vim-abolish', event = LazyFileEvents },
  { 'AndrewRadev/splitjoin.vim', event = LazyFileEvents },
  { 'godlygeek/tabular', event = LazyFileEvents },
  { 'bkad/CamelCaseMotion', event = LazyFileEvents },
  { 'romainl/vim-qf', lazy = true },

  'machakann/vim-swap',
  'wellle/targets.vim',
  {
    'neovim/nvim-lspconfig',
    event = LazyFileEvents,
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make'
      },
    },
    keys = {
      { '<C-p>', '<cmd>Telescope find_files<CR>' },
      { '<Leader>fg', '<cmd>Telescope live_grep<CR>' },
      { '<Leader>be', '<cmd>Telescope buffers<CR>' },
      { '<Leader>gw', '<cmd>Telescope grep_string<CR>' },
      { '<Leader>fh', '<cmd>Telescope man_pages<CR>' },
      { '<Leader>fm', '<cmd>Telescope keymaps<CR>' },
    },
    opts = {
      pickers = {
        live_grep = {
          file_ignore_patterns = { 'node_modules', '.git' },
          additional_args = function(_)
            return { "--hidden" }
          end,
        },
        find_files = {
          file_ignore_patterns = { 'node_modules', '.git' },
          hidden = true,
        },
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdateSync',
    event = { "BufNewFile", "BufReadPost" },
    dependencies = {
      "RRethy/nvim-treesitter-endwise",
      "RRethy/vim-illuminate",
    },
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "ruby" },
      },
      incremental_selection = {
        enable = true,
      },
      indent = {
        enable = true,
        disable = { "ruby" }, -- ruby indenting doesn't seem to be working yet
      },
      endwise = {
        enable = true,
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
      },
      ensure_installed = {
        'bash',
        'cmake',
        'diff',
        'dockerfile',
        'git_config',
        'git_rebase',
        'gitcommit',
        'gitignore',
        'go',
        'groovy',
        'hcl',
        'html',
        'http',
        'java',
        'javascript',
        'jq',
        'json',
        'kotlin',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'properties',
        'proto',
        'puppet',
        'python',
        'ruby',
        'rust',
        'sql',
        'ssh_config',
        'terraform',
        'toml',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      },
    },
    config = function(_, opts)
      local config = require("nvim-treesitter.configs")
      config.setup(opts)
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function(_, _)
      vim.cmd([[colorscheme tokyonight-moon]])
    end,
  },
  {
    "stevearc/conform.nvim",
    -- we need to add a tool to manage these formatters/tools.
    -- @see `mason-tools-installer`
    -- https://github.com/stevearc/conform.nvim/issues/104
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = false })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      log_level = vim.log.levels.INFO,
      formatters_by_ft = {
        sql = { "sqlfluff" },
      },
      formatters = {
        sqlfluff = {
          args = { "fix", "--force", "-" },
        },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      local conf = require("lualine").get_config()

      local new_conf = vim.tbl_deep_extend("force", conf, {
        sections = {
          lualine_c = {
            {
              "filename",
              path = 1,
            },
          },
        },
      })

      return new_conf
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500 -- milliseconds
    end,
    opts = {},
  },

  -- Language-specific plugins
  { 'chase/vim-ansible-yaml', ft = { "ansible" } },
  { 'markcornick/vim-bats', ft = { "bash" } },
  { 'elubow/cql-vim', lazy = true }, -- Cassandra syntax highlighting; can this be replaced with Treesitter?
  { 'guns/vim-clojure-highlight', ft = { "clojure" } },
  { 'guns/vim-clojure-static', ft = { "clojure" } } ,
  { 'guns/vim-sexp', ft = { 'clojure' } },
  { 'tpope/vim-dispatch', ft = { 'clojure' } },
  { 'tpope/vim-fireplace', ft = { 'clojure' } },
  { 'tpope/vim-salve', ft = { 'clojure' } },
  { 'tpope/vim-sexp-mappings-for-regular-people', ft = { 'clojure' } },
  { 'kchmck/vim-coffee-script', ft = { "coffee" } },
  { 'elixir-lang/vim-elixir', ft = { "elixir" } },
  { 'fatih/vim-go', ft = { "go" }, build = ':GoInstallBinaries' },
  { 'jparise/vim-graphql', ft = { "graphql" } }, -- TODO can this be deprecated for Treesitter?
  { 'akhaku/vim-java-unused-imports', ft = { "java" } },
  { 'pangloss/vim-javascript', ft = { "javascript", "jsx" } },
  { 'google/vim-jsonnet', ft = { "jsonnet" } },
  { 'mxw/vim-jsx', ft = { "jsx" } },
  { 'Glench/Vim-Jinja2-Syntax', ft = { "jinja" } },
  { 'aklt/plantuml-syntax', ft = { "plantuml" } },
  { 'tpope/vim-markdown', ft = { "markdown" } },
  { 'rodjek/vim-puppet', ft = { "puppet" } },
  { 'tpope/vim-cucumber', ft = { "ruby" } },
  { 'tpope/vim-rails', ft = { "ruby" } },
  { 'rust-lang/rust.vim', ft = { "rust" } },
  { 'jergason/scala.vim', ft = { "scala" } },
  { 'derekwyatt/vim-scala', ft = { "scala" } },
  { 'hashivim/vim-terraform', ft = { "terraform" } },
  { 'leafgarland/typescript-vim', ft = { "typescript" } },
  { 'lmeijvogel/vim-yaml-helper', ft = { "yaml" } },
})
