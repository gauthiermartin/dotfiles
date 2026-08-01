-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- Cmd-Shift-X is the inner application leader; Herdr keeps Cmd-X.
-- vim.keycode is required: the literal string "<D-S-x>" is not a keycode.
vim.g.mapleader = vim.keycode("<D-S-x>")

-- Python
vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff"
