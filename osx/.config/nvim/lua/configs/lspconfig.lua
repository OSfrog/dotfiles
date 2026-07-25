local servers = require "configs.lsp_servers"

local blink_ok, blink = pcall(require, "blink.cmp")
if blink_ok then
  local nvchad_capabilities = vim.deepcopy(require("nvchad.configs.lspconfig").capabilities)
  vim.lsp.config("*", {
    capabilities = blink.get_lsp_capabilities(nvchad_capabilities),
  })
end

-- Deno and the TS server must not both attach to the same buffer. denols owns
-- any directory tree that has a deno.json (e.g. supabase/functions); ts_ls owns
-- everything else. Overriding root_dir also drops denols' default `.git`
-- marker, which would otherwise make it attach across the whole repo.
vim.lsp.config("denols", {
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
    if root then
      on_dir(root)
    end
  end,
})

vim.lsp.config("ts_ls", {
  root_dir = function(bufnr, on_dir)
    -- Inside a Deno project, defer to denols.
    if vim.fs.root(bufnr, { "deno.json", "deno.jsonc" }) then
      return
    end

    local root = vim.fs.root(bufnr, { "tsconfig.json", "jsconfig.json", "package.json", ".git" })
    if root then
      on_dir(root)
    end
  end,
})

vim.lsp.enable(servers)
