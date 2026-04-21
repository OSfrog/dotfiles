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

-- Servers that exist in nvim-lspconfig's lsp/ runtimepath but must never
-- auto-start in this environment. Without this exclusion, calling
-- `:lsp enable` (no args) would pick them up for TypeScript/HTML buffers.
local excluded_servers = { "angularls", "rome", "tsgo", "glsl_analyzer" }

require("mason-lspconfig").setup {
  ensure_installed = servers,
  -- v2 default; auto-enables any server installed via Mason that has
  -- a config in nvim-lspconfig, so listed servers light up automatically.
  automatic_enable = {
    exclude = excluded_servers,
  },
}

-- Belt-and-suspenders: explicitly disable these servers so they are never
-- started regardless of how they were enabled (e.g. stale Mason install,
-- project-local config, or a broad `:lsp enable` call).
vim.lsp.enable(excluded_servers, false)
