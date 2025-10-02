-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

local map = vim.keymap.set

map(
	{ "n", "i", "v" },
	"<C-b>",
	"<cmd>:lua require('snacks.explorer').open()<cr>",
	{ silent = true, desc = "Toggle file explorer" }
)

map({ "n", "i", "v" }, "<C-z>", "<cmd>undo<cr>", { desc = "Undo" })

map("x", "<BS>", '"_d', { desc = "Delete without yanking" })

map("n", ";", ":", { desc = "CMD enter command mode" })

map({ "n", "i", "v" }, "<C-;>", ":")

map({ "n", "i", "v" }, "<C-x>", ":wq<CR>", { desc = "Save and quit" })

map({ "n", "i", "v" }, "<C-;>", "<Esc>:", { desc = "Go to command mode" })

-- normal mode: select all
map("n", "<C-a>", "ggVG", { noremap = true, silent = true })

-- insert mode: exit insert mode, select all, then go back to insert
map("i", "<C-a>", "<Esc>ggVG", { noremap = true, silent = true })

-- visual mode: select all
map("v", "<C-a>", "ggVG", { noremap = true, silent = true })

-- visual mode tab shifts right
vim.keymap.set("v", "<Tab>", ">gv", { noremap = true, silent = true })

-- visual mode shift+tab shifts left
vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true, silent = true })

-- Split window vertically (new window below)
vim.keymap.set({ "n", "i", "v" }, "<C-\\>", "<C-w>v", { desc = "Split window vertically" })

-- Split window horizontally (new window to the right)
vim.keymap.set({ "n", "i", "v" }, "<C-->", "<C-w>s", { desc = "Split window horizontally" })

-- Close the current window split
vim.keymap.set("n", "<C-S-\\>", "<C-w>c", { desc = "Close current window" })
vim.keymap.set("n", "<C-S-->", "<C-w>c", { desc = "Close current window" })
