-- Neovim 0.11+ / nvim-lspconfig v1+ / mason-lspconfig v2 setup.
--
-- NvChad's `defaults()` already:
--   * sets capabilities + on_init globally via `vim.lsp.config("*", ...)`
--   * registers the `LspAttach` autocmd that wires keymaps
--   * configures and enables `lua_ls`
--
-- Here we just declare which extra servers to ensure-install via Mason
-- and enable. Per-server overrides are merged with `vim.lsp.config(name, ...)`.

local servers = {
  "html",
  "cssls",
  "ts_ls",
  "clangd",
  "yamlls",
  "tailwindcss",
  "eslint",
  "rust_analyzer",
  "marksman",
}

-- Per-server overrides must be registered BEFORE mason-lspconfig.setup()
-- so that automatic_enable picks them up when enabling servers.
vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
      },
    },
  },
})

require("mason-lspconfig").setup {
  ensure_installed = servers,
  -- v2 default; auto-enables any server installed via Mason that has
  -- a config in nvim-lspconfig, so listed servers light up automatically.
  automatic_enable = true,
}
