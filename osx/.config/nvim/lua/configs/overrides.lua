local M = {}

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
      hidden = true,
      file_ignore_patterns = { "node_modules", },
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
