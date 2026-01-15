local LazyFileEvents = require("config.utils.lazy").LazyFileEvents

---@module 'lazy.types'
---@type LazyPluginSpec[]
return {
    -- Everything else!!!
    { "arthurxavierx/vim-caser", event = LazyFileEvents }, -- Change word casing with vim motion
    -- vim-codefmt doesn't seem to work with Lazy
    -- TODO can this be deprecated in favor of another formatting tool?
    --  {
    --	  'google/vim-codefmt',
    --	  dependencies = { 'google/vim-glaive', 'google/vim-maktaba' },
    --  },
    --
    {
        -- TODO can this be substituted with something that `mini.nvim` offers, or Treesitter text objects?
        "dewyze/vim-ruby-block-helpers",
        ft = { "ruby" },
    },
    {
        "janko-m/vim-test",
        dependencies = {
            {
                "benmills/vimux",
                dependencies = {
                    "jgdavey/vim-turbux",
                    "samguyjones/vim-crosspaste",
                },
                keys = {
                    { "<Leader>rx", "<cmd>wa<CR> <cmd>VimuxCloseRunner<CR>", desc = "Close runner pane" },
                    { "<Leader>ri", "<cmd>wa<CR> <cmd>VimuxInspectRunner<CR>", desc = "Inspect runner pane" },
                    { "<Leader>vs", '"vy :call VimuxRunCommand(@v)<CR>', mode = "v", desc = "Run highlighted" },
                    { "<Leader>vs", 'vip "vy :call VimuxRunCommand(@v)<CR>', desc = "Run contiguous lines" },
                },
                init = function()
                    vim.g["test#strategy"] = "vimux"
                end,
            },
        },
        cmd = { "TestNearest", "TestFile", "TestLast" },
        keys = {
            { "<Leader>rb", "<cmd>wa<CR> <cmd>TestFile<CR>", desc = "Run buffer" },
            { "<Leader>rf", "<cmd>wa<CR> <cmd>TestNearest<CR>", desc = "Run focused" },
            { "<Leader>rl", "<cmd>wa<CR> <cmd>TestLast<CR>", desc = "Run last test again" },
        },
    },
    { "kshenoy/vim-signature", event = LazyFileEvents }, -- Used to add/remove/go-to marks
    { "kana/vim-textobj-user", lazy = true }, -- used to create custom text objects; TODO mark for deletion
    { "mattn/emmet-vim", lazy = true }, -- used for a expanding abbreviations/adding tags to HTML; TODO mark for deletion
    { "mileszs/ack.vim", lazy = true }, -- used for searching. We use fzf + rg; TODO mark for deletion
    {
        "pgr0ss/vim-github-url",
        event = LazyFileEvents,
        keys = {
            { "<LocalLeader>gh", "<cmd>GitHubURL<CR>", desc = "show URL to view the file under cursor on GitHub" },
        },
    },
    { "tfnico/vim-gradle", event = LazyFileEvents },
    {
        "tpope/vim-projectionist",
        lazy = false,
        priority = 12,
    },
    { "tpope/vim-fugitive" },
    { "tpope/vim-ragtag", event = LazyFileEvents },
    {
        "tpope/vim-rake",
        lazy = false,
        priority = 11,
        keys = {
            { "<Leader>AA", "<cmd>A<CR>", desc = "Alternate file" },
            { "<Leader>AV", "<cmd>AV<CR>", desc = "Alternate w/ Vertical Split" },
            { "<Leader>AS", "<cmd>AS<CR>", desc = "Alternate w/ Horizontal Split" },
        },
    },
    { "tpope/vim-repeat" },
    { "tpope/vim-rhubarb", events = LazyFileEvents },
    { "tpope/vim-surround" },
    { "tpope/vim-unimpaired" },
    { "tpope/vim-vinegar" },
    { "vim-scripts/Align", lazy = true },
    { "vim-scripts/VimClojure", lazy = true },
    { "vim-scripts/groovyindent-unix", lazy = true },
    { "vim-scripts/mako.vim", lazy = true },
    { "vim-scripts/matchit.zip", lazy = true },
    {
        "tweekmonster/wstrip.vim",
        ft = { "ruby", "lua", "java", "python", "c", "cpp", "sql", "puppet", "rust", "go" },
        config = function(plugin, _)
            vim.g.wstrip_highlight = 0

            vim.api.nvim_create_autocmd("FileType", {
                pattern = plugin.ft,
                callback = function()
                    vim.b.wstrip_highlight = 1
                end,
            })
            -- these settings adapted from https://github.com/braintreeps/vim_dotfiles/blob/master/vimrc#L97-L102
        end,
    },
    -- TODO Removable plugins??
    { "tpope/vim-abolish", event = LazyFileEvents },
    { "AndrewRadev/splitjoin.vim", event = LazyFileEvents },
    { "godlygeek/tabular", event = LazyFileEvents },
    { "bkad/CamelCaseMotion", event = LazyFileEvents },
    { "romainl/vim-qf", lazy = true },

    {
        -- Swap delimeted items
        "machakann/vim-swap",
        keys = {
            { "g>", desc = "Swap with next" },
            { "g<", desc = "Swap with previous" },
            { "gs", desc = "Swap interactive" },
        },
    },
    { "wellle/targets.vim" },

    -- Language-specific plugins
    { "chase/vim-ansible-yaml", ft = { "ansible" } },
    { "markcornick/vim-bats", ft = { "bash" } },
    { "elubow/cql-vim", lazy = true }, -- Cassandra syntax highlighting; can this be replaced with Treesitter?
    { "guns/vim-clojure-highlight", ft = { "clojure" } },
    { "guns/vim-clojure-static", ft = { "clojure" } },
    { "guns/vim-sexp", ft = { "clojure" } },
    { "tpope/vim-dispatch", ft = { "clojure" } },
    { "tpope/vim-fireplace", ft = { "clojure" } },
    { "tpope/vim-salve", ft = { "clojure" } },
    { "tpope/vim-sexp-mappings-for-regular-people", ft = { "clojure" } },
    { "kchmck/vim-coffee-script", ft = { "coffee" } },
    { "elixir-lang/vim-elixir", ft = { "elixir" } },
    {
        "fatih/vim-go",
        ft = { "go" },
        build = ":GoInstallBinaries",
        init = function()
            -- Disable features that we have other plugins for
            vim.g.go_def_mapping_enabled = 0 -- Let nvim-lspconfig handle gd
            vim.g.go_doc_keywordprg_enabled = 0 -- Let nvim-lspconfig handle K
            vim.g.go_fmt_autosave = 0 -- Let conform.nvim handle formatting
            vim.g.go_imports_autosave = 0 -- Let conform.nvim handle imports
            vim.g.go_code_completion_enabled = 0 -- Let blink.cmp handle completion
            -- Keep useful vim-go features like :GoCoverage, :GoTest, etc.
            vim.g.go_highlight_types = 1
            vim.g.go_highlight_fields = 1
            vim.g.go_highlight_functions = 1
            vim.g.go_highlight_function_calls = 1
        end,
    },
    { "jparise/vim-graphql", ft = { "graphql" } }, -- TODO can this be deprecated for Treesitter?
    { "akhaku/vim-java-unused-imports", ft = { "java" } },
    { "pangloss/vim-javascript", ft = { "javascript", "jsx" } },
    { "google/vim-jsonnet", ft = { "jsonnet" } },
    { "mxw/vim-jsx", ft = { "jsx" } },
    { "Glench/Vim-Jinja2-Syntax", ft = { "jinja" } },
    { "aklt/plantuml-syntax", ft = { "plantuml" } },
    { "tpope/vim-markdown", ft = { "markdown" } },
    { "rodjek/vim-puppet", ft = { "puppet" } },
    { "tpope/vim-cucumber", ft = { "ruby" } },
    {
        "tpope/vim-rails",
        lazy = false,
        priority = 10,
        ft = { "ruby" },
        init = function()
            vim.g["rails_projections"] = {
                ["script/*.rb"] = {
                    test = "spec/script/{}_spec.rb",
                },
                ["spec/script/*_spec.rb"] = {
                    alternate = "script/{}.rb",
                },
                ["app/lib/*.rb"] = {
                    test = "spec/lib/{}_spec.rb",
                },
                ["lib/tasks/*.rake"] = {
                    test = "spec/lib/tasks/{}_rake_spec.rb",
                },
            }
        end,
    },
    { "rust-lang/rust.vim", ft = { "rust" } },
    { "jergason/scala.vim", ft = { "scala" } },
    { "derekwyatt/vim-scala", ft = { "scala" } },
    { "hashivim/vim-terraform", ft = { "terraform" } },
    { "leafgarland/typescript-vim", ft = { "typescript" } },
    { "lmeijvogel/vim-yaml-helper", ft = { "yaml" } },
}
