local M = {}

M.LazyFileEvents = { "BufReadPost", "BufNewFile", "BufWritePre" }
M.SwitchColorschemeKeyMap = {
	"<leader>uC",
	function()
		require("telescope.builtin").colorscheme({ enable_preview = true })
	end,
	desc = "Colorscheme with preview",
}

return M
