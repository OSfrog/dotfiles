local slow_format_filetypes = {}

local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { { "prettierd", "prettier" } },
    typescript = { { "prettierd", "prettier" } },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  format_on_save = function(bufnr)
    -- Determine if the current file type is marked as slow
    if slow_format_filetypes[vim.bo[bufnr].filetype] then
      -- Optionally, perform logic for slow file types here
      return { lsp_fallback = true }
    else
      local function on_format(err)
        -- Mark the file type as slow if a timeout error occurs
        if err and err:match "timeout$" then
          slow_format_filetypes[vim.bo[bufnr].filetype] = true
        end
      end

      -- Return format options for non-slow file types
      return { timeout_ms = 200, lsp_fallback = true }, on_format
    end
  end,
}

require("conform").setup(options)
