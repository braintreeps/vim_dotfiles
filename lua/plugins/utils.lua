return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			scroll = {
				enabled = true,
			},
			dashboard = {
				enabled = false,
				preset = {
					header = [[
	██████╗ ██████╗  █████╗ ██╗███╗   ██╗████████╗██████╗ ███████╗███████╗
	██╔══██╗██╔══██╗██╔══██╗██║████╗  ██║╚══██╔══╝██╔══██╗██╔════╝██╔════╝
	██████╔╝██████╔╝███████║██║██╔██╗ ██║   ██║   ██████╔╝█████╗  █████╗
	██╔══██╗██╔══██╗██╔══██║██║██║╚██╗██║   ██║   ██╔══██╗██╔══╝  ██╔══╝
	██████╔╝██║  ██║██║  ██║██║██║ ╚████║   ██║   ██║  ██║███████╗███████╗
	╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝

					]],
				}
			},
			lazygit = {
				config = {
					os = {
						edit = '[ -z "$NVIM" ] && (nvim -- {{filename}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{filename}})',
						editAtLine = '[ -z "$NVIM" ] && (nvim +{{line}} -- {{filename}}) || (nvim --server "$NVIM" --remote-send "q" &&  nvim --server "$NVIM" --remote {{filename}} && nvim --server "$NVIM" --remote-send ":{{line}}<CR>")',
						editAtLineAndWait = 'nvim +{{line}} {{filename}}',
						openDirInEditor = '[ -z "$NVIM" ] && (nvim -- {{dir}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{dir}})',
					}
				}
			},
			zen = {},
		},
		keys = {
			{ "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
			{ "<leader>gb", function() Snacks.git.blame_line() end, desc = "[G]it [B]lame"},
			{ "<leader>b.", function() Snacks.scratch() end, desc = "New Scratch [b]uffer" },
			{ "<leader>bS", function() Snacks.scratch.select() end, desc = "Scratch [b]uffer [S]elect" },
			{ "<leader>uZ", function() Snacks.zen() end, desc = "[Z]en mode" },
		}
	},
}
