-- Coding: Faster coding with features such as snippets, autocompletion, and more.

local LazyFileEvents = require("lazy_utils").LazyFileEvents

return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
	{
		"numToStr/Comment.nvim",
		event = LazyFileEvents,
		opts = {},
	},
	{
		"hrsh7th/nvim-cmp",
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
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-emoji",
			"andersevenrud/cmp-tmux",
			"davidsierradz/cmp-conventionalcommits",
			"onsails/lspkind-nvim",
			"zbirenbaum/copilot-cmp",
		},
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			local defaults = require("cmp.config.default")()

			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({ { name = "conventionalcommits" } }),
			})

			cmp.setup({
				sorting = defaults.sorting,
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = lspkind.cmp_format({
						menu = {
							buffer = "[Buffer]",
							nvim_lsp = "[LSP]",
							path = "[Path]",
							emoji = "[Emoji]",
							tmux = "[Tmux]",
						},
					}),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<Tab>"] = cmp.mapping(function(fallback)
						-- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
						if cmp.visible() then
							local entry = cmp.get_selected_entry()
							if not entry then
								cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
							end
							cmp.confirm()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "copilot" },
					{ name = "nvim_lsp", max_item_count = 7 },
					{ name = "path", max_item_count = 7 },
				}, {
					{
						name = "buffer",
						option = {
							-- show visible buffers
							get_bufnrs = function()
								local bufs = {}
								for _, win in ipairs(vim.api.nvim_list_wins()) do
									bufs[vim.api.nvim_win_get_buf(win)] = true
								end
								return vim.tbl_keys(bufs)
							end,
						},
					},
					{ name = "tmux", max_item_count = 5 },
					{ name = "emoji", max_item_count = 5 },
				}),
				window = {
					documentation = cmp.config.window.bordered(),
				},
			})
		end,
	},
}
