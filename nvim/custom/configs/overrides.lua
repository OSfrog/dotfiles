local M = {}

M.treesitter = {
  auto_install = true,
  autotag = { enable = true, enable_close_on_slash = true }, -- autotag issue, https://github.com/windwp/nvim-ts-autotag/issues/125
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
    "prettier",

    -- c/cpp stuff
    "clangd",
    "clang-format",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },

  actions = { open_file = { quit_on_open = true } },
}

M.blankline = {
  filetype_exclude = {
    "help",
    "terminal",
    "alpha",
    "packer",
    "lspinfo",
    "TelescopePrompt",
    "TelescopeResults",
    "nvchad_cheatsheet",
    "lsp-installer",
    "norg",
    "Empty",
  },
  show_end_of_line = true,
  show_foldtext = true,
  show_trailing_blankline_indent = false,
  show_first_indent_level = false,
  show_current_context = true,
  show_current_context_start = false,
  vim.api.nvim_set_hl(0, "IndentBlanklineContextChar", { nocombine = true, fg = "none" }),
  vim.api.nvim_set_hl(0, "IndentBlanklineContextStart", { nocombine = false, underline = false, special = "none" }),
}

M.cmp = {
  mapping = {
    ["<ESC>"] = require("cmp").mapping(function(fallback)
      if require("cmp").visible() then
        require("cmp").abort()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "nvim_lua" },
    { name = "path" },
    { name = "nvim_lsp_signature_help" },
  },
}

return M
