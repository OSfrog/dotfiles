---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

M.ui = {
  theme = "tokyonight",
  theme_toggle = {"tokyonight", "catppuccin"},

  hl_override = highlights.override,
  hl_add = highlights.add,

  statusline = {
  theme = "minimal", -- default/vscode/vscode_colored/minimal
  -- default/round/block/arrow separators work only for default statusline theme
  -- round and block will work for minimal theme only
  separator_style = "block"
  },

  nvdash = {
    load_on_startup = true,
    header  = {
       '███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
       '████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
       '██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
       '██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
       '██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
       '╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
       '                                                  ',
       '                 [ @yungleeee ]                   ',
  },

    buttons = {
      { "  Find File", "Spc f f", "Telescope find_files" },
      { "  Recent Files", "Spc f h", "Telescope oldfiles" },
      { "  Find Word", "Spc f g", "Telescope live_grep" },
      { "  Bookmarks", "Spc b m", "Telescope marks" },
      { "  Themes", "Spc t h", "Telescope themes" },
      { "  Mappings", "Spc c h", "NvCheatsheet" },
    },

  }
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"


return M
