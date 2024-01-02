---@type MappingsTable
local M = {}

M.general = {
  n = {
    -- 2 newlines up/down into insert with vim-unimpaired
    ["<leader>o"] = { "]<space>o", "insert 2 newlines down into insert mode", opts = { remap = true } },
    ["<leader>O"] = { "[<space>O", "insert 2 newlines up into insert mode", opts = { remap = true } },

    -- Window Splits
    ["ss"] = { ":split<Return><C-w>w", "vertical window split" },
    ["sv"] = { ":vsplit<Return><C-w>w", "horizontal window split" },

    -- Move window
    ["s<Left>"] = { "<C-w>h", "move to window left" },
    ["s<Up>"] = { "<C-w>k", "move to window up" },
    ["s<Down>"] = { "<C-w>j", "move to window down" },
    ["s<Right>"] = { "<C-w>l", "move to window right" },
    ["sh"] = { "<C-w>h", "move to window left" },
    ["sk"] = { "<C-w>k", "move to window up" },
    ["sj"] = { "<C-w>j", "move to window down" },
    ["sl"] = { "<C-w>l", "move to window right" },
    ["<C-w><left>"] = { "<C-w><", "move split left " },
    ["<C-w><right>"] = { "<C-w>>", "move split right " },
    ["<C-w><up>"] = { "<C-w>+", "increase split size vertically" },
    ["<C-w><down>"] = { "<C-w>-", "decrease split size vertically" },

    -- Increment/decrement
    ["+"] = { "<C-a>", "increment" },
    ["-"] = { "<C-x>", "decrement" },

    -- Delete a word backwards
    ["dw"] = { 'vb"_d', "delete word backwards" },

    -- Select all
    ["<C-a>"] = { "gg<S-v>G", "select all" },

    -- Toggle relativenumber
    ["<leader>tn"] = { ":set invrelativenumber<CR>", "toggle relativenumber" },

    -- Substitute word under cursor
    ["<leader>*"] = { ":%s/\\<<C-r><C-w>\\>/", "substitute word under cursor" },

    ["<leader>tt"] = {
      function()
        require("base46").toggle_transparency()
      end,
      "toggle transparency",
    },
  },
  i = {
    -- jj to Escape
    ["jj"] = { "<ESC>", "escape insert mode" },
  },
  v = {
    -- Search for selected text, forwards or backwards
    ["*"] = {
      ":<C-U>let old_reg=getreg('\"')<Bar>let old_regtype=getregtype('\"')<CR>gvy/<C-R><C-R>=substitute(escape(@\", '/\\.*$^~['), '\\_s\\+', '\\\\\\_s\\\\+', 'g')<CR><CR>gV:call setreg('\"', old_reg, old_regtype)<CR>",
      "search selected text forwards",
    },
    ["#"] = {
      ":<C-U>let old_reg=getreg('\"')<Bar>let old_regtype=getregtype('\"')<CR>gvy?<C-R><C-R>=substitute(escape(@\", '?\\.*$^~['), '\\_s\\+', '\\\\\\_s\\\\+', 'g')<CR><CR>gV:call setreg('\"', old_reg, old_regtype)<CR>",
      "search selected text backwards",
    },

    -- Stop cursor from jumping back to starting point when yanking
    ["y"] = { "ygv<esc>", "better yank" },
  },
}

M.tabufline = {
  n = {
    ["<leader>X"] = {
      function()
        require("nvchad.tabufline").closeOtherBufs()
      end,
      "Close all buffers except current",
    },
  },
}

M.lspconfig = {
  n = {
    ["gh"] = {
      function()
        vim.lsp.buf.hover()
      end,
      "lsp hover",
    },
    -- ["<C-k>"] = {
    --   function()
    --     vim.diagnostic.goto_prev()
    --   end,
    --   "goto prev",
    -- },
    --
    -- ["<C-j>"] = {
    --   function()
    --     vim.diagnostic.goto_next()
    --   end,
    --   "goto_next",
    -- },
    ["gR"] = {
      function()
        require("nvchad.renamer").open()
      end,
      "lsp rename",
    },
  },
}

M.telescope = {
  n = {
    ["<leader>fg"] = { "<cmd> Telescope live_grep <CR>", "live grep" },
    ["<leader>fh"] = { "<cmd> Telescope oldfiles <CR>", "find oldfiles" },
  },
}
-- more keybinds!

M.lspsaga = {
  n = {
    ["<C-k>"] = { "<cmd>Lspsaga diagnostic_jump_prev<CR>", "goto prev" },
    ["<C-j>"] = { "<cmd>Lspsaga diagnostic_jump_next<CR>", "goto next" },
    ["<leader>ca"] = { "<cmd>Lspsaga code_action<CR>", "code action" },
  },
}

M.git = {
  n = {
    ["<leader>gl"] = { "<CMD>GitBlameToggle<CR>", "  Blame line" },
  },
}

return M
