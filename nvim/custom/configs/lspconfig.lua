local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "tsserver", "clangd", "intelephense" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Autoformat on save
vim.cmd [[
    autocmd BufWritePre *.lua,*.js,*.ts,*.tsx,*.html,*.css,*.json,*.md lua vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
]]

--
-- lspconfig.pyright.setup { blabla}
