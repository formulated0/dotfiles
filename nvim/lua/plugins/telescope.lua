return {
	"nvim-telescope/telescope.nvim",
	keys = {
		-- Disable the default Telescope live_grep keymap
		{ "<leader>/", false },

		-- Map Ctrl+F to search within the CURRENT BUFFER
		{
			"<C-f>",
			function()
				require("telescope.builtin").current_buffer_fuzzy_find()
			end,
			desc = "Find in Current Buffer",
		},

		-- Map Ctrl+Shift+F to search the ENTIRE PROJECT
		{
			"<C-S-f>",
			function()
				require("telescope.builtin").live_grep({
					grep_open_files = false,
				})
			end,
			desc = "Find in Files (Grep)",
		},
	},
}
