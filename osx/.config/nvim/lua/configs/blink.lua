return {
  keymap = {
    preset = "enter",
    ["<Tab>"] = {
      function(cmp)
        if require("copilot.suggestion").is_visible() then
          cmp.hide()
          require("copilot.suggestion").accept()
        else
          vim.api.nvim_feedkeys("  ", "i", true)
        end
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

  sources = {
    providers = {
      snippets = {
        should_show_items = function(ctx)
          return ctx.trigger.initial_kind ~= "trigger_character"
        end,
      },
    },
  },
}
