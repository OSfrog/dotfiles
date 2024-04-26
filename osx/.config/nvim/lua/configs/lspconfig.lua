local nvchad_on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "html", "cssls", "lua_ls", "tsserver", "clangd", "vale_ls", "yamlls", "tailwindcss" }

local function on_attach(client, bufnr)
  nvchad_on_attach(client, bufnr)

  vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { buffer = bufnr, desc = "Lspsaga Code Action" })
end

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- typescript
lspconfig.tsserver.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}
