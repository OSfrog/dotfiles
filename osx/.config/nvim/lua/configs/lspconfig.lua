local servers = {
  "html",
  "cssls",
  "lua_ls",
  "ts_ls",
  "clangd",
  "prismals",
  "yamlls",
  "tailwindcss",
  "eslint",
  "rust_analyzer",
  "glsl_analyzer",
}

local blink_ok, blink = pcall(require, "blink.cmp")
if blink_ok then
  local nvchad_capabilities = vim.deepcopy(require("nvchad.configs.lspconfig").capabilities)
  vim.lsp.config("*", {
    capabilities = blink.get_lsp_capabilities(nvchad_capabilities),
  })
end

vim.lsp.enable(servers)
