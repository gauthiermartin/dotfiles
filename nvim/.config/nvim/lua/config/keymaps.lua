-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set({ "n", "x", "o" }, "<leader>;", ";", { desc = "Repeat f/t motion" })

-- Mirror Herdr's split mnemonic: v = vertical divider, h = horizontal divider.
vim.keymap.set("n", "<leader>v", "<cmd>vsplit<cr>", { desc = "Split vertical" })
vim.keymap.set("n", "<leader>h", "<cmd>split<cr>", { desc = "Split horizontal" })
