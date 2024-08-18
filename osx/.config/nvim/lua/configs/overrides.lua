local M = {}

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

M.telescope = {
  pickers = {
    find_files = {
      follow = true,
      no_ignore = true,
      hidden = true,
      file_ignore_patterns = { "node_modules", ".git" },
    },
  },
  extensions_list = {
    "themes",
    "terms",
    "fzf",
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
    },
  },
}

return M
