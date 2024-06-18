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

require("lazy").setup({
  'akhaku/vim-java-unused-imports',
  'aklt/plantuml-syntax',
  'arthurxavierx/vim-caser',
  -- Show git diff via Vim sign column.
  'airblade/vim-gitgutter',
  -- vim-codefmt doesn't seem to work with Lazy
  -- TODO can this be deprecated in favor of another formatting tool?
--  {
--	  'google/vim-codefmt',
--	  dependencies = { 'google/vim-glaive', 'google/vim-maktaba' },
--  },
  'benmills/vim-commadown',
  'bkad/CamelCaseMotion',
  'chase/vim-ansible-yaml',
  -- 'dewyze/vim-ruby-block-helpers', -- TODO can this be substituted with something that `mini.nvim` offers, or Treesitter text objects?
  {
    'derekwyatt/vim-scala',
    ft = { "scala" },
  },
  {
    'elixir-lang/vim-elixir',
    ft = { "elixir" },
  },
  {
    'elubow/cql-vim',
    lazy = true,
  },
  {
    'fatih/vim-go',
    ft = { "go" },
    commit = '8c4db1c61432511a3aa55971dabb2171cbcba7b1',
    build = ':GoInstallBinaries',
  },
  'Glench/Vim-Jinja2-Syntax',
  'godlygeek/tabular',
  'tpope/vim-markdown',
  'google/vim-jsonnet',
  'guns/vim-clojure-highlight',
  'guns/vim-clojure-static',
  'hashivim/vim-terraform',
  'henrik/vim-indexed-search',
  {
    'janko-m/vim-test',
    dependencies = {
      {
        'benmills/vimux',
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
  'jergason/scala.vim',
  {
    'jgdavey/vim-turbux',
    branch = 'main'
  },
  'junegunn/vim-easy-align',
  {
    'jparise/vim-graphql',
    commit = '7ecedede603d16de5cca5ccefbde14d642b0d697',
  },
  'kshenoy/vim-signature',
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make'
  },
  'kana/vim-textobj-user',
  'kchmck/vim-coffee-script',
  'kien/rainbow_parentheses.vim',
  'lmeijvogel/vim-yaml-helper',
  'markcornick/vim-bats',
  'mattn/emmet-vim',
  'mileszs/ack.vim',
  -- TODO this doesn't seem to be functional with Lazy. Can we replicate this with TS or another plugin?
  -- 'nelstrom/vim-textobj-rubyblock',
  'pangloss/vim-javascript',
  'mxw/vim-jsx',
  'pgr0ss/vim-github-url',
  'prabirshrestha/async.vim',
  {
    'prabirshrestha/asyncomplete.vim',
    ft = { 'java' },
  },
  {
    'prabirshrestha/asyncomplete-lsp.vim',
    ft = { 'java' },
  },
  'prabirshrestha/vim-lsp',
  'rust-lang/rust.vim',
  {
    'hrsh7th/nvim-cmp',
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
      "saadparwaiz1/cmp_luasnip",
      'hrsh7th/cmp-nvim-lsp',
      -- 'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-emoji',
      'davidsierradz/cmp-conventionalcommits',
      'onsails/lspkind-nvim',
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      local luasnip = require("luasnip")
      luasnip.config.setup({})

      local defaults = require("cmp.config.default")()

      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({ { name = "conventionalcommits" } })
      })

      cmp.setup({
        sorting = defaults.sorting,
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
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
          -- <c-l> will move you to the right of each of the expansion locations
          -- <c-h> will move you backwards
          ["<C-l>"] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { "i", "s" }),
          ["<C-h>"] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "path" },
        }, {
            -- { name = "cmdline" },
            { name = "emoji" },
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
  'tfnico/vim-gradle',
  {
    'numToStr/Comment.nvim',
    opts = {},
  },
  'tpope/vim-cucumber',
  {
    'tpope/vim-salve',
    ft = { 'clojure' },
  },
  'tpope/vim-projectionist',
  {
    'tpope/vim-dispatch',
    ft = { 'clojure' }
  },
  {
    'tpope/vim-fireplace',
    ft = { 'clojure' }
  },
  {
    'tpope/vim-sexp-mappings-for-regular-people',
    ft = { 'clojure' }
  },
  {
    'guns/vim-sexp',
    ft = { 'clojure' }
  },
  'tpope/vim-fugitive',
  'tpope/vim-ragtag',
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
  'tpope/vim-rails',
  'tpope/vim-repeat',
  'tpope/vim-rhubarb',
  'tpope/vim-surround',
  'tpope/vim-unimpaired',
  'tpope/vim-vinegar',
  'tpope/vim-abolish',
  'uarun/vim-protobuf',
  -- {
  --   'vim-ruby/vim-ruby',
  -- --  commit = '84565856e6965144e1c34105e03a7a7e87401acb',
  -- },
  'vim-scripts/Align',
  'vim-scripts/VimClojure',
  'vim-scripts/groovyindent-unix',
  'vim-scripts/mako.vim',
  'vim-scripts/matchit.zip',
  'rodjek/vim-puppet',
  {
    'tweekmonster/wstrip.vim',
    commit = '02826534e60a492b58f9515f5b8225d86f74fbc8',
  },
  'leafgarland/typescript-vim',
  'AndrewRadev/splitjoin.vim',
  'machakann/vim-swap',
  'wellle/targets.vim',
  'romainl/vim-qf',
  'wellle/tmux-complete.vim',
  'samguyjones/vim-crosspaste',

  'w0rp/ale',
  'neovim/nvim-lspconfig',
  'nvim-lua/plenary.nvim', -- Required for telescope
  {
    'nvim-telescope/telescope.nvim',
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
    build = ':TSUpdate',
    dependencies = {
      'RRethy/nvim-treesitter-endwise',
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
    "RRethy/vim-illuminate",
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
})
