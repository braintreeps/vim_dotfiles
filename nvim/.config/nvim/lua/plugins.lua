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
  'benmills/vimux',
  'bkad/CamelCaseMotion',
  {
    'cespare/vim-toml',
    branch = 'main',
  },
  'chase/vim-ansible-yaml',
  'dewyze/vim-ruby-block-helpers', -- TODO can this be substituted with something that `mini.nvim` offers, or Treesitter text objects?
  'derekwyatt/vim-scala',
  'ekalinin/Dockerfile.vim',
  'elixir-lang/vim-elixir',
  'elubow/cql-vim',
  {
    'fatih/vim-go',
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
  'janko-m/vim-test',
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
    'scrooloose/nerdtree',
    keys = {
      { '<Leader>nt', '<cmd>NERDTree<CR>' },
      { '<Leader>nf', '<cmd>NERDTreeFind<CR>' },
    },
  },
  'tfnico/vim-gradle',
  'tomtom/tcomment_vim',
  'tpope/vim-cucumber',
  'tpope/vim-endwise',
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
  'tpope/vim-rake',
  'tpope/vim-rails',
  'tpope/vim-repeat',
  'tpope/vim-rhubarb',
  'tpope/vim-surround',
  'tpope/vim-unimpaired',
  'tpope/vim-vinegar',
  'tpope/vim-abolish',
  'uarun/vim-protobuf',
  {
    'vim-ruby/vim-ruby',
    commit = '84565856e6965144e1c34105e03a7a7e87401acb',
  },
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
    commit = '80cdb00b221f69348afc4fb4b701f51eb8dd3120',
    keys = {
      { '<C-p>', '<cmd>Telescope find_files<CR>' },
      { '<Leader>fg', '<cmd>Telescope live_grep<CR>' },
      { '<Leader>be', '<cmd>Telescope buffers<CR>' },
      { '<Leader>gw', '<cmd>Telescope grep_string<CR>' },
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
    opts = {
      highlight = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
      },
      indent = {
        enable = true,
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
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function(_, opts)
      vim.cmd([[colorscheme tokyonight-moon]])
    end,
  },
})
