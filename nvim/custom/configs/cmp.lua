local M = {}
local copilot_status_ok, copilot_cmp_comparators = pcall(require, "copilot_cmp.comparators")
local list_contains = vim.list_contains or vim.tbl_contains
pcall(function()
  dofile(vim.g.base46_cache .. "cmp")
end)

local function deprioritize_snippet(entry1, entry2)
  local types = require "cmp.types"

  if entry1:get_kind() == types.lsp.CompletionItemKind.Snippet then
    return false
  end
  if entry2:get_kind() == types.lsp.CompletionItemKind.Snippet then
    return true
  end
end

local function under(entry1, entry2)
  local _, entry1_under = entry1.completion_item.label:find "^_+"
  local _, entry2_under = entry2.completion_item.label:find "^_+"
  entry1_under = entry1_under or 0
  entry2_under = entry2_under or 0
  if entry1_under > entry2_under then
    return false
  elseif entry1_under < entry2_under then
    return true
  end
end

local function limit_lsp_types(entry, ctx)
  local kind = entry:get_kind()
  local line = ctx.cursor.line
  local col = ctx.cursor.col
  local char_before_cursor = string.sub(line, col - 1, col - 1)
  local char_after_dot = string.sub(line, col, col)
  local types = require "cmp.types"

  if char_before_cursor == "." and char_after_dot:match "[a-zA-Z]" then
    return kind == types.lsp.CompletionItemKind.Method
        or kind == types.lsp.CompletionItemKind.Field
        or kind == types.lsp.CompletionItemKind.Property
  elseif string.match(line, "^%s+%w+$") then
    return kind == types.lsp.CompletionItemKind.Function or kind == types.lsp.CompletionItemKind.Variable
  elseif kind == require("cmp").lsp.CompletionItemKind.Text then
    return false
  end

  return true
end

local disabled_buftypes = {
  "terminal",
  "prompt",
}

M.cmp = {
  enabled = function()
    local disabled = false
    disabled = disabled or (list_contains(disabled_buftypes, vim.api.nvim_get_option_value("buftype", { buf = 0 })))
    disabled = disabled or (vim.fn.reg_recording() ~= "")
    disabled = disabled or (vim.fn.reg_executing() ~= "")
    disabled = disabled or (require("cmp.config.context").in_treesitter_capture "comment" == true)
    disabled = disabled or (require("cmp.config.context").in_syntax_group "Comment" == true)
    disabled = disabled or (vim.api.nvim_get_mode().mode == "c")

    if disabled then
      return not disabled
    end

    return true
  end,
  window = {
    completion = {
      scrolloff = 0,
      col_offset = 0,
      scrollbar = false,
    },
  },
  completion = {
    completeopt = "menu,menuone,noinsert",
    autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
    keyword_length = 2,
  },
  experimental = {
    ghost_text = {
      hl_group = "Comment",
    },
  },
  mapping = {
    ["<Up>"] = require("cmp").mapping.select_prev_item(),
    ["<Down>"] = require("cmp").mapping.select_next_item(),
    ["<Tab>"] = require("cmp").mapping(function(fallback)
      if require("copilot.suggestion").is_visible() then
        if require("cmp").visible() then
          require("cmp").close()
        end
        require("copilot.suggestion").accept()
      elseif require("cmp").visible() then
        require("cmp").select_next_item()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
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
  -- explanations: https://github.com/hrsh7th/nvim-cmp/blob/main/doc/cmp.txt#L425
  performance = {
    debounce = 30,
    throttle = 20,
    async_budget = 0.8,
    max_view_entries = 10,
    fetching_timeout = 250,
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  sources = {
    {
      name = "nvim_lsp",
      keyword_length = 2,
      entry_filter = limit_lsp_types,
    },
    {
      name = "ctags",
      option = {
        executable = "ctags",
        trigger_characters = { "." },
      },
      keyword_length = 5,
      max_item_count = 2,
    },
    { name = "treesitter" },
    { name = "nvim_lsp_document_symbol" },
    { name = "luasnip",                 max_item_count = 2 },
    { name = "nvim_lua" },
    { name = "npm",                     keyword_length = 4 },
  },
  matching = {
    disallow_fuzzy_matching = true,
    disallow_fullfuzzy_matching = true,
    disallow_partial_fuzzy_matching = true,
    disallow_partial_matching = false,
    disallow_prefix_unmatching = true,
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      -- Definitions of compare function https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/compare.lua
      copilot_cmp_comparators.prioritize or function() end,
      deprioritize_snippet,
      require("cmp").config.compare.exact,
      require("cmp").config.compare.locality,
      require("cmp").config.compare.recently_used,
      under,
      require("cmp").config.compare.score,
      require("cmp").config.compare.kind,
      require("cmp").config.compare.length,
      require("cmp").config.compare.order,
      require("cmp").config.compare.sort_text,
    },
  },
}

return M
