local overrides = require "configs.overrides"

return {
  {
    "stevearc/conform.nvim",
    lazy = true,
    event = "BufWritePre",
    opts = function()
      return require "configs.conform"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = { ui = { border = "single" } },
      },
      "mason-org/mason-lspconfig.nvim",
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
            accept_line = false,
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
  },
  {
    "folke/sidekick.nvim",
    opts = {
      -- add any options here
      cli = {
        mux = {
          backend = "tmux",
          enabled = false,
        },
      },
    },
    keys = {
      {
        "<c-.>",
        function()
          require("sidekick.cli").focus()
        end,
        mode = { "n", "x", "i", "t" },
        desc = "Sidekick Switch Focus",
      },
      {
        "<leader>aa",
        function()
          require("sidekick.cli").toggle { focus = true }
        end,
        desc = "Sidekick Toggle CLI",
        mode = { "n", "v" },
      },
      {
        "<leader>ap",
        function()
          require("sidekick.cli").select_prompt()
        end,
        desc = "Sidekick Ask Prompt",
        mode = { "n", "v" },
      },
      {
        "<leader>ac",
        function()
          require("sidekick.cli").toggle({ name = "copilot", focus = true })
        end,
        desc = "Sidekick Toggle Copilot CLI",
        mode = { "n", "v" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "vimdoc",
        "lua",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "toml",
        "markdown",
        "bash",
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
    event = "BufReadPre",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      require("Comment").setup {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "mxsdev/nvim-dap-vscode-js",
    },
    config = function()
      require "configs.dap"
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
    cmd = "GitBlameToggle",
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
    branch = "v3.0",
    lazy = true,
    build = function()
      require("base46").load_all_highlights()
    end,
  },
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles" },
    lazy = true,
  },
}
