return {
  keymap = {
    preset = "enter",
    ["<Tab>"] = {
      function()
        local copilot = require "copilot.suggestion"
        if copilot.is_visible() then
          copilot.accept()
          return true
        end
      end,
      "fallback",
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
