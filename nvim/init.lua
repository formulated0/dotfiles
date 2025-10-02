-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

require("cord").setup({
	editor = {
		tooltip = "neovim",
	},
	display = {
		theme = "atom",
		flavor = "accent",
		view = "full",
	},
})

require("Comment").setup()

vim.wo.number = true
vim.wo.relativenumber = false

vim.o.wrap = true
vim.o.linebreak = true
vim.o.textwidth = 0
