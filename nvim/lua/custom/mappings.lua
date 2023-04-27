---@type MappingsTable
local M = {}

-- 2 newlines down into insert mode using vim-unimpaired
vim.api.nvim_set_keymap("n", "<leader>o", "]<space>o", { noremap = true, silent = true })

-- 2 newlines up into insert mode using vim-unimpaired
vim.api.nvim_set_keymap("n", "<leader><S-O>", "[<space>O", { noremap = true, silent = true })

M.general = {
  n = {

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
  },
}

M.tabs = {
  n = {
    -- Delete current buffer
    ["<leader><C-w>"] = { ":bp\\|bd #<CR>", "delete current buffer" },
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
    ["<Shift><C-j>"] = {
      function()
        vim.diagnostic.goto_prev()
      end,
      "goto prev",
    },

    ["<C-j>"] = {
      function()
        vim.diagnostic.goto_next()
      end,
      "goto_next",
    },
    ["gR"] = {
      function()
        require("nvchad_ui.renamer").open()
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

return M
