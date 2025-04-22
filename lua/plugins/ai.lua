
return {
	{
		"zbirenbaum/copilot.lua",
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
		},
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "zbirenbaum/copilot.lua" },
			{
				"MeanderingProgrammer/render-markdown.nvim",
				dependencies = {
					'nvim-treesitter/nvim-treesitter',
					'nvim-tree/nvim-web-devicons',
				},
				opts = {
					file_types = { 'markdown', 'copilot-chat' },
				},
			},
		},
		build = "make tiktoken",
		opts = function()
			local user = vim.env.SSH_USERNAME or vim.env.USER or "User"
			user = user:sub(1, 1):upper() .. user:sub(2)

			return {
				sticky = "#buffer",
				highlight_headers = false,
				separator = "---",
				question_header = "#   " .. user .. " ",
				answer_header = "##   Copilot ",
				error_header = "> [!ERROR] Error",
			}
		end,
		keys = {
			{ "<Leader>aa", "<cmd>CopilotChatToggle<CR>", desc = "Copilot: [a]i [a]sk", mode = { "n", "v" } },
			{ "<Leader>ap", "<cmd>CopilotChatPrompts<CR>", desc = "Copilot: [a]i [p]rompt", mode = { "n", "v" } },
			{ "<leader>ae", "<cmd>CopilotChatExplain<CR>", desc = "Copilot: [a]i [e]xplain", mode = { "v" } },
			{ "<leader>ar", "<cmd>CopilotChatReview<CR>", desc = "Copilot: [a]i [r]eview", mode = { "n", "v" } },
			{
				"<leader>aq",
				function()
					vim.ui.input({
						prompt = "Quick Chat: ",
					}, function(input)
							if input ~= "" then
								require("CopilotChat").ask(input)
							end
						end)
				end,
				desc = "Copilot: [a]i [q]uick chat",
			},
		},
		config = function(_, opts)
			local chat = require("CopilotChat")

			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-chat",
				callback = function()
					vim.opt_local.relativenumber = false
					vim.opt_local.number = false
				end
			})

			chat.setup(opts)
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		depdendencies = {
			{ "zbirenbaum/copilot.lua" },
		},
		opts = {},
	},
	{
		'AndreM222/copilot-lualine',
	}
}
