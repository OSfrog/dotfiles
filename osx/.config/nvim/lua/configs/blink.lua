return {
  keymap = {
    preset = "enter",
    ["<Tab>"] = {
      function(cmp)
        if require("copilot.suggestion").is_visible() then
          cmp.hide()
          require("copilot.suggestion").accept()
        end
      end,
    },
    ["<C-h"] = {
      function(cmp)
        cmp.show { providers = { "lsp" } }
      end,
    },
  },

  fuzzy = {
    sorts = {
      "exact",
      "score",
      "sort_text",
    },
  },
}
