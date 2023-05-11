local null_ls = require "null-ls"

local format = null_ls.builtins.formatting
local lint = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

local sources = {
  -- Code actions
  code_actions.eslint_d,

  -- webdev stuff
  format.deno_fmt,

  -- Lua
  format.stylua,

  -- Shell
  format.shfmt,

  -- Prettier
  format.prettier.with { filetypes = { "html", "markdown", "css", "php" } },

  -- Diagnostics
  lint.php,
  lint.shellcheck,
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup {
  debug = true,
  sources = sources,
  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format()
        end,
      })
    end
  end,
}
