local nvchad_on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local nvchad_capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = {
  "html",
  "cssls",
  "lua_ls",
  "ts_ls",
  "clangd",
  "vale_ls",
  "yamlls",
  "tailwindcss",
  "eslint",
  "rust_analyzer",
  "glsl_analyzer",
}

local function on_attach(client, bufnr)
  nvchad_on_attach(client, bufnr)

  vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { buffer = bufnr, desc = "Lspsaga Code Action" })
end

-- -- lsps with default config
-- for _, lsp in ipairs(servers) do
--   -- local blink_capabilities = require("blink.cmp").get_lsp_capabilities(nvchad_capabilities)
--   -- local combined_capabilities = vim.tbl_deep_extend("force", nvchad_capabilities, blink_capabilities)
--   lspconfig[lsp].setup {
--     on_attach = on_attach,
--     on_init = on_init,
--     capabilities = nvchad_capabilities,
--   }
-- end
