local overrides = require "custom.configs.overrides"
local cmp_opt = require "custom.configs.cmp"

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "nvimtools/none-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
      {
        "glepnir/lspsaga.nvim",
        config = function()
          require "custom.configs.lspsaga"
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },
  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      require "custom.configs.lspsaga"
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = cmp_opt.cmp,
    dependencies = {
      "hrsh7th/cmp-copilot",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        dependencies = {
          {
            "zbirenbaum/copilot-cmp",
            config = function()
              require("copilot").setup {
                panel = {
                  enabled = true,
                  auto_refresh = true,
                },
                suggestion = {
                  enabled = true,
                  auto_trigger = true,
                  accept = false, -- disable built-in keymapping
                },
                filetypes = {
                  markdown = true,
                  yaml = true,
                },
              }

              -- hide copilot suggestions when cmp menu is open
              -- to prevent odd behavior/garbled up suggestions
              local cmp_status_ok, cmp = pcall(require, "cmp")
              if cmp_status_ok then
                cmp.event:on("menu_opened", function()
                  vim.b.copilot_suggestion_hidden = true
                end)

                cmp.event:on("menu_closed", function()
                  vim.b.copilot_suggestion_hidden = false
                end)
              end
            end,
          },
        },
        config = function()
          require("copilot").setup {
            suggestion = {
              enabled = false,
              auto_trigger = false,
              keymap = {
                accept_word = false,
                accept_line = false,
              },
            },
            panel = {
              enabled = false,
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
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "cmp")
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        if item.kind == "Color" then
          item.kind = "⬤"
          format_kinds(entry, item)
          return require("tailwindcss-colorizer-cmp").formatter(entry, item)
        end
        return format_kinds(entry, item)
      end
      local cmp = require "cmp"

      cmp.setup(opts)

      -- local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      -- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = opts.mapping,
        sources = {
          { name = "buffer" },
        },
      })
    end,
  },
  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "JoosepAlviste/nvim-ts-context-commentstring", ft = "javascriptreact" },
      "windwp/nvim-ts-autotag",
    },
    opts = overrides.treesitter,
  },

  {
    "numToStr/Comment.nvim",
    dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
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
    "lukas-reineke/indent-blankline.nvim",
    opts = overrides.blankline,
  },

  -- Install a plugin
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
      require "custom.configs.neoscroll"
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    config = function()
      require("trouble").setup()
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        prompt_prefix = "   ",
      },
      extensions_list = { "themes", "terms", "fzf" },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    },
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    -- config = function()
    --   require("telescope").load_extension "fzf"
    -- end,
  },
  {
    "prettier/vim-prettier",
    run = "yarn install",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "css",
      "html",
      "json",
      "markdown",
      "vue",
      "yaml",
      "scss",
      "graphql",
      "python",
      "lua",
      "ruby",
      "php",
    },
  },
  -- {
  --   "github/copilot.vim",
  --   lazy = false,
  --   config = function()
  --     require "custom.configs.copilot"
  --   end,
  -- },
  {
    "jonahgoldwastaken/copilot-status.nvim",
    event = "LspAttach",
    config = function()
      require("copilot_status").setup {
        icons = {
          idle = " ",
          error = " ",
          offline = " ",
          warning = " ",
          loading = " ",
        },
        debug = false,
      }
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
  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },
}

return plugins
