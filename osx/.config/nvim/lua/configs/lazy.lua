return {
  defaults = { lazy = true },
  install = { colorscheme = { "nvchad" } },

  -- Lazy defaults to unlimited task concurrency outside Windows. Limiting
  -- fetches avoids overwhelming network paths that reset concurrent GitHub
  -- connections during a full sync.
  concurrency = 10,

  git = {
    -- copilot.lua now vendors the GitHub Copilot LSP's native binaries for
    -- every platform directly in its repo (~500MB+ checkout as of mid-2026),
    -- so the default 120s clone timeout is no longer enough on normal
    -- connections. Give clones/fetches more room before lazy kills them.
    timeout = 600,
  },

  ui = {
    icons = {
      ft = "",
      lazy = "󰂠 ",
      loaded = "",
      not_loaded = "",
    },
    border = "rounded",
  },

  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
}
