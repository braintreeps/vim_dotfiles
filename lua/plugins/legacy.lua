local LazyFileEvents = require("lazy_utils").LazyFileEvents

return {
	-- Everything else!!!
	{ "arthurxavierx/vim-caser", event = LazyFileEvents }, -- Change word casing with vim motion
	-- vim-codefmt doesn't seem to work with Lazy
	-- TODO can this be deprecated in favor of another formatting tool?
	--  {
	--	  'google/vim-codefmt',
	--	  dependencies = { 'google/vim-glaive', 'google/vim-maktaba' },
	--  },
	-- 'dewyze/vim-ruby-block-helpers', -- TODO can this be substituted with something that `mini.nvim` offers, or Treesitter text objects?
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
		keys = {
			{ "<Leader>rb", "<cmd>wa<CR> <cmd>TestFile<CR>", desc = "Run buffer" },
			{ "<Leader>rf", "<cmd>wa<CR> <cmd>TestNearest<CR>", desc = "Run focused" },
			{ "<Leader>rl", "<cmd>wa<CR> <cmd>TestLast<CR>", desc = "Run last test again" },
		},
	},
	{ "junegunn/vim-easy-align", event = LazyFileEvents }, -- Used to align text; this should be driven by an LSP
	{ "kshenoy/vim-signature", event = LazyFileEvents }, -- Used to add/remove/go-to marks
	{ "kana/vim-textobj-user", lazy = true }, -- used to create custom text objects; TODO mark for deletion
	{ "mattn/emmet-vim", lazy = true }, -- used for a expanding abbreviations/adding tags to HTML; TODO mark for deletion
	{ "mileszs/ack.vim", lazy = true }, -- used for searching. We use fzf + rg; TODO mark for deletion
	{ "pgr0ss/vim-github-url", event = LazyFileEvents },
	{ "tfnico/vim-gradle", event = LazyFileEvents },
	{ "tpope/vim-projectionist" },
	{ "tpope/vim-fugitive", event = LazyFileEvents },
	{ "tpope/vim-ragtag", event = LazyFileEvents },
	{
		"tpope/vim-rake",
		keys = {
			{ "<Leader>AA", "<cmd>A<CR>", desc = "Alternate file" },
			{ "<Leader>AV", "<cmd>AV<CR>", desc = "Alternate w/ Vertical Split" },
			{ "<Leader>AS", "<cmd>AS<CR>", desc = "Alternate w/ Horizontal Split" },
		},
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
	{ "tweekmonster/wstrip.vim",
		lazy = false,
		init = function()
			vim.cmd("let g:wstrip_highlight = 0")
			-- these settings adapted from https://github.com/braintreeps/vim_dotfiles/blob/master/vimrc#L97-L102
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "ruby", "*.java", "*.python", "*.c", "*.cpp", "*.sql", "*.puppet", "*.rust" },
				callback = function(_args)
					vim.cmd("let b:wstrip_auto = 1")
				end,
			})
		end
	},
	-- TODO Removable plugins??
	{ "tpope/vim-abolish", event = LazyFileEvents },
	{ "AndrewRadev/splitjoin.vim", event = LazyFileEvents },
	{ "godlygeek/tabular", event = LazyFileEvents },
	{ "bkad/CamelCaseMotion", event = LazyFileEvents },
	{ "romainl/vim-qf", lazy = true },

	{ "machakann/vim-swap" },
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
	{ "fatih/vim-go", ft = { "go" }, build = ":GoInstallBinaries" },
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
	{ "tpope/vim-rails", ft = { "ruby" } },
	{ "rust-lang/rust.vim", ft = { "rust" } },
	{ "jergason/scala.vim", ft = { "scala" } },
	{ "derekwyatt/vim-scala", ft = { "scala" } },
	{ "hashivim/vim-terraform", ft = { "terraform" } },
	{ "leafgarland/typescript-vim", ft = { "typescript" } },
	{ "lmeijvogel/vim-yaml-helper", ft = { "yaml" } },
}
