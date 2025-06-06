-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

local M = {}

---@type Base46HLGroupsList
M.override = {
  Comment = {
    italic = true,
    fg = { "grey", 15 },
  },
  ["@comment"] = {
    fg = { "grey", 15 },
  },
  NvDashAscii = {
    bg = "none",
    fg = "blue",
  },

  NvDashButtons = {
    bg = "none",
    fg = "light_grey",
  },
  Visual = {
    bg = "light_grey",
  },

  Search = {
    bg = "light_grey",
    fg = "white",
  },
}

---@type HLTable
M.add = {
  NvimTreeOpenedFolderName = { fg = "green", bold = true },
}

return M
