-- LSP: configure the Language Server Protocol (LSP) client.

local LazyFileEvents = require("lazy_utils").LazyFileEvents

return {
	{
		"neovim/nvim-lspconfig",
		event = LazyFileEvents,
	},
}
