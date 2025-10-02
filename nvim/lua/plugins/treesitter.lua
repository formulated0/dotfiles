-- File: ~/.config/nvim/lua/plugins/treesitter.lua

return {
	-- This first line is the name of the plugin as it appears in your plugin manager
	"nvim-treesitter/nvim-treesitter",

	-- The 'opts' table is where you override the plugin's default settings
	opts = {
		-- We only care about the 'incremental_selection' feature
		incremental_selection = {
			enable = true, -- Keep the feature enabled
			keymaps = {
				-- This is the crucial part.
				-- We are telling treesitter to NOT create a keymap for 'node_decremental',
				-- which is the "shrink selection" command that uses <BS> by default.
				node_decremental = false,
			},
		},
	},
}
