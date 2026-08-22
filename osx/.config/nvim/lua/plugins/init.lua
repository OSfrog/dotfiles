local overrides = require "configs.overrides"

return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = function()
      return require "configs.conform"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {},
      },
      {
        "mason-org/mason-lspconfig.nvim",
        opts = {
          automatic_enable = false,
          ensure_installed = require "configs.lsp_servers",
        },
      },
    },
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  {
    "glepnir/lspsaga.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- optional
    },
    event = "LspAttach",
    config = function()
      require "configs.lspsaga"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    init = function(plugin)
      vim.opt.rtp:prepend(plugin.dir .. "/runtime")
    end,
    config = function()
      local languages = {
        "bash",
        "css",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
      }

      require("nvim-treesitter").setup {}
      require("nvim-treesitter").install(languages)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        pattern = languages,
        callback = function(args)
          vim.treesitter.start(args.buf)
        end,
      })
    end,
  },
  { import = "nvchad.blink.lazyspec" },
  {
    "saghen/blink.cmp",
    opts = require "configs.blink",
  },
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept_word = false,
            accept_line = "<Tab>",
          },
        },
        filetypes = {
          gitcommit = false,
          TelescopePrompt = false,
        },
        server_opts_overrides = {
          trace = "verbose",
          settings = {
            advanced = {
              listCount = 3,
              inlineSuggestCount = 3,
            },
          },
        },
      }
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      window = {
        layout = "float",
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = overrides.telescope,
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
          require("ts_context_commentstring").setup {
            enable_autocmd = false,
          }
        end,
      },
    },
    config = function()
      require("Comment").setup {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
  },
  {
    "tpope/vim-surround",
    event = "BufRead",
  },
  {
    "tpope/vim-unimpaired",
    event = "BufRead",
  },
  {
    "tpope/vim-repeat",
    event = "BufRead",
  },
  {
    "karb94/neoscroll.nvim",
    event = "BufRead",
    config = function()
      require "configs.neoscroll"
    end,
  },
  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup()
      -- refer to `configuration to change defaults`
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },
  {
    "f-person/git-blame.nvim",
  },
  {
    "kdheepak/lazygit.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = "LazyGit",
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufEnter",
    config = true,
  },
  {
    "nvchad/ui",
    config = function()
      require "nvchad"
    end,
  },

  {
    "nvchad/base46",
    lazy = true,
    branch = "v3.0",
    build = function()
      require("base46").load_all_highlights()
    end,
  },
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
    cmd = "Leet",
    dependencies = {
      -- include a picker of your choice, see picker section for more details
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    image_support = false,
    opts = {
      lang = "typescript",
      plugins = {
        non_standalone = true,
      },
    },
  },
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        mux = {
          backend = "tmux",
          enabled = false,
        },
      },
      nes = {
        enabled = false,
      },
    },
    keys = {
      {
        "<c-.>",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Sidekick Toggle",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function()
          require("sidekick.cli").select()
        end,
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
        desc = "Select CLI",
      },
      {
        "<leader>ad",
        function()
          require("sidekick.cli").close()
        end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>at",
        function()
          require("sidekick.cli").send { msg = "{this}" }
        end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function()
          require("sidekick.cli").send { msg = "{file}" }
        end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function()
          require("sidekick.cli").send { msg = "{selection}" }
        end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function()
          require("sidekick.cli").prompt()
        end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
      -- Example of a keybinding to open Claude directly
      {
        "<leader>ac",
        function()
          require("sidekick.cli").toggle { name = "codex", focus = true }
        end,
        desc = "Sidekick Toggle Codex",
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles" },
    lazy = true,
    keys = {
      {
        "<leader>df",
        function()
          local diffview = require "diffview"

          if require("diffview.lib").get_current_view() then
            diffview.close()
          else
            diffview.open {}
          end
        end,
        desc = "Toggle Diffview",
      },
    },
    opts = function()
      local actions = require "diffview.actions"

      return {
        keymaps = {
          file_panel = {
            ["<C-b>"] = false,
            ["<C-f>"] = false,
            { "n", "<C-u>", actions.scroll_view(-0.5), { desc = "Scroll the view up" } },
            { "n", "<C-d>", actions.scroll_view(0.5), { desc = "Scroll the view down" } },
          },
          file_history_panel = {
            ["<C-b>"] = false,
            ["<C-f>"] = false,
            { "n", "<C-u>", actions.scroll_view(-0.5), { desc = "Scroll the view up" } },
            { "n", "<C-d>", actions.scroll_view(0.5), { desc = "Scroll the view down" } },
          },
        },
      }
    end,
  },
}
