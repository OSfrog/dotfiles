return {
  keymap = {
    preset = "enter",
    ["<Tab>"] = {
      function(cmp)
        local copilot = require "copilot.suggestion"
        if copilot.is_visible() then
          cmp.hide()
          copilot.accept()
        else
          vim.api.nvim_feedkeys("  ", "i", true)
        end
      end,
      "fallback",
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
