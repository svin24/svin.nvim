return { -- Useful plugin to show you pending keybinds.
	"folke/which-key.nvim",
	event = "VimEnter",
	opts = {
		icons = { mappings = false },
	},
	config = function(_, opts)
		require("which-key").setup(opts)
	end,
}
