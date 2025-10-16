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
    dependencies = {
      "williamboman/mason.nvim",
      {
        "williamboman/mason-lspconfig.nvim",
        config = function()
          require("mason").setup {}
          require("mason-lspconfig").setup {
            ensure_installed = {
              "lua_ls",
              "html",
              "cssls",
              "ts_ls",
              "clangd",
              "prismals",
              "eslint",
              "vale_ls",
              "yamlls",
            },
          }
          require("nvchad.configs.lspconfig").defaults()
          require "configs.lspconfig"
        end,
      },
    },
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
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
      },
    },
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
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "html",
        "css",
        "javascript",
        "json",
        "toml",
        "markdown",
        "bash",
        "lua",
        "tsx",
        "typescript",
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
      {
        "LiadOz/nvim-dap-repl-highlights",
        config = true,
        dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
        build = function()
          if not require("nvim-treesitter.parsers").has_parser "dap_repl" then
            vim.cmd ":TSInstall dap_repl"
          end
        end,
      },
    },
    config = function()
      require("configs.dap").setup()
    end,
    keys = {
      {
        "<Leader>da",
        "<CMD>lua require('dap').continue()<CR>",
        desc = "Continue",
      },
      {
        "<Leader>db",
        "<CMD>lua require('dap').toggle_breakpoint()<CR>",
        desc = "Toggle Breakpoint",
      },
      {
        "<Leader>dB",
        "<CMD>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
        desc = "Conditional Breakpoint",
      },
      {
        "<Leader>dd",
        "<CMD>lua require('dap').continue()<CR>",
        desc = "Continue",
      },
      {
        "<Leader>dh",
        "<CMD>lua require('dapui').eval()<CR>",
        desc = "Evaluate",
      },
      {
        "<Leader>di",
        "<CMD>lua require('dap').step_into()<CR>",
        desc = "Step Into",
      },
      {
        "<Leader>do",
        "<CMD>lua require('dap').step_out()<CR>",
        desc = "Step Out",
      },
      {
        "<Leader>dO",
        "<CMD>lua require('dap').step_over()<CR>",
        desc = "Step Over",
      },
      {
        "<Leader>dt",
        "<CMD>lua require('dap').terminate()<CR>",
        desc = "Terminate",
      },
      {
        "<Leader>du",
        "<CMD>lua require('dapui').open()<CR>",
        desc = "Open UI",
      },
      {
        "<Leader>dc",
        "<CMD>lua require('dapui').close()<CR>",
        desc = "Close UI",
      },
      {
        "<Leader>dw",
        "<CMD>lua require('dapui').float_element('watches', { enter = true })<CR>",
        desc = "Watches",
      },
      {
        "<Leader>ds",
        "<CMD>lua require('dapui').float_element('scopes', { enter = true })<CR>",
        desc = "Scopes",
      },
      {
        "<Leader>dr",
        "<CMD>lua require('dapui').float_element('repl', { enter = true })<CR>",
        desc = "REPL",
      },
    },
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
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen" },
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
}
