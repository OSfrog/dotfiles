-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

-- Add this to your mappings.lua file or another appropriate Lua configuration file

-- vim.opt.ignorecase = true  -- Ignore case when searching
-- vim.opt.smartcase = true   -- Don't ignore case when search pattern has an uppercase character
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.wrap = false          -- Don't wrap lines

-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=300 }
  augroup END
]]