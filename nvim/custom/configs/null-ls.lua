local null_ls = require "null-ls"

local format = null_ls.builtins.formatting
local lint = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

local prettier_filetypes = {
  "html",
  "markdown",
  "css",
  "php",
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "json",
  "yaml",
  "xml",
}

local sources = {
  -- Code actions
  code_actions.eslint,
  -- code_actions.gitsigns,

  -- webdev stuff
  format.deno_fmt,

  -- Lua
  format.stylua,

  -- Shell
  format.shfmt,

  -- Fish
  format.fish_indent,

  -- -- Prettier
  -- format.prettierd.with {
  --   filetypes = prettier_filetypes,
  -- },

  -- Diagnostics
  lint.php,
  lint.shellcheck,
  lint.fish,
  -- lint.eslint,
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
          vim.lsp.buf.format { bufnr = bufnr }
        end,
      })
    end
  end,
}
