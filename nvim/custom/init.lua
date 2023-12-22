vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.wrap = false -- Don't wrap lines
vim.opt.scrolloff = 10 -- Always show 10 lines vertically when scrolling

-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=300 }
  augroup END
]]

-- Set filetype for .env files
vim.cmd [[
  augroup dotenv
    autocmd!
    autocmd BufRead,BufNewFile *.env set filetype=dotenv
  augroup END
]]

require "custom.utils.autocmd"
