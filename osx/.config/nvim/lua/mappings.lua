require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- General Normal Mode Mappings
map("n", "<leader>o", "]<space>o", { remap = true, desc = "insert 2 newlines down into insert mode" })
map("n", "<leader>O", "[<space>O", { remap = true, desc = "insert 2 newlines up into insert mode" })

map("n", "ss", ":split<Return><C-w>w", { desc = "vertical window split" })
map("n", "sv", ":vsplit<Return><C-w>w", { desc = "horizontal window split" })

map("n", "s<Left>", "<C-w>h", { desc = "move to window left" })
map("n", "s<Up>", "<C-w>k", { desc = "move to window up" })
map("n", "s<Down>", "<C-w>j", { desc = "move to window down" })
map("n", "s<Right>", "<C-w>l", { desc = "move to window right" })
map("n", "sh", "<C-w>h", { desc = "move to window left" })
map("n", "sk", "<C-w>k", { desc = "move to window up" })
map("n", "sj", "<C-w>j", { desc = "move to window down" })
map("n", "sl", "<C-w>l", { desc = "move to window right" })

map("n", "<C-w><left>", "<C-w><", { desc = "move split left" })
map("n", "<C-w><right>", "<C-w>>", { desc = "move split right" })
map("n", "<C-w><up>", "<C-w>+", { desc = "increase split size vertically" })
map("n", "<C-w><down>", "<C-w>-", { desc = "decrease split size vertically" })

map("n", "+", "<C-a>", { desc = "increment" })
map("n", "-", "<C-x>", { desc = "decrement" })

map("n", "dw", 'vb"_d', { desc = "delete word backwards" })

map("n", "<C-a>", "gg<S-v>G", { desc = "select all" })

map("n", "<leader>tn", ":set invrelativenumber<CR>", { desc = "toggle relativenumber" })

map("n", "<leader>*", ":%s/\\<<C-r><C-w>\\>/", { desc = "substitute word under cursor" })

map("n", "<leader>tt", function()
  require("base46").toggle_transparency()
end, { desc = "toggle transparency" })

-- Copilot Chat
map("n", "<leader>cc", function()
  require("CopilotChat").toggle {}
end, { desc = "toggle copilot chat" })

map("n", "<leader>ccn", function()
  local before = vim.tbl_map(function(buf)
    return buf
  end, vim.api.nvim_list_bufs())
  require("CopilotChat").open {
    window = {
      layout = "replace",
    },
  }
  vim.defer_fn(function()
    local after = vim.api.nvim_list_bufs()
    for _, buf in ipairs(after) do
      if not vim.tbl_contains(before, buf) then
        vim.bo[buf].buflisted = true
      end
    end
  end, 50)
end, { desc = "CopilotChat - New chat in a buffer" })

--CopilotChat - Quick chat with current buffer
map("n", "<leader>ccq", function()
  local input = vim.fn.input "Quick Chat: "
  if input ~= "" then
    require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
  end
end, { desc = "CopilotChat - Quick chat" })

--CopilotChat - Quick chat with visual selection
map("v", "<leader>cc", function()
  local input = vim.fn.input "Quick Chat: "
  if input ~= "" then
    require("CopilotChat").ask(input, { selection = require("CopilotChat.select").visual })
  end
end, { desc = "CopilotChat - Quick chat - Visual" })

-- CopilotChat - Prompt actions
map("v", "<leader>cq", function()
  local actions = require "CopilotChat.actions"
  require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
end, { desc = "CopilotChat - Prompt actions" })

-- General Insert Mode Mappings
map("i", "jj", "<ESC>", { desc = "escape insert mode" })

-- General Visual Mode Mappings
map(
  "v",
  "*",
  ":<C-U>let old_reg=getreg('\"')<Bar>let old_regtype=getregtype('\"')<CR>gvy/<C-R><C-R>=substitute(escape(@\", '/\\.*$^~['), '\\_s\\+', '\\\\\\_s\\\\+', 'g')<CR><CR>gV:call setreg('\"', old_reg, old_regtype)<CR>",
  { desc = "search selected text forwards" }
)
map(
  "v",
  "#",
  ":<C-U>let old_reg=getreg('\"')<Bar>let old_regtype=getregtype('\"')<CR>gvy?<C-R><C-R>=substitute(escape(@\", '?\\.*$^~['), '\\_s\\+', '\\\\\\_s\\\\+', 'g')<CR><CR>gV:call setreg('\"', old_reg, old_regtype)<CR>",
  { desc = "search selected text backwards" }
)
map("v", "y", "ygv<esc>", { desc = "better yank" })

map("v", "p", '"_dP', { desc = "paste without yanking" })

-- Tabufline Mappings
map("n", "<leader>X", function()
  require("nvchad.tabufline").closeAllBufs(false)
end, { desc = "Close all buffers except current" })

-- LSPConfig Mappings
map("n", "gh", function()
  vim.lsp.buf.hover {
    border = "single",
  }
end, { desc = "lsp hover" })
map("n", "gR", function()
  require "nvchad.lsp.renamer"()
end, { desc = "lsp rename" })
map("i", "<C-h>", function()
  require("blink.cmp").show { providers = { "lsp" } }
end, { desc = "Trigger completion menu" })

-- Telescope Mappings
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "live grep" })
map("n", "<leader>fh", "<cmd>Telescope oldfiles<CR>", { desc = "find oldfiles" })
map("n", "<leader>fa", function()
  require("telescope.builtin").find_files {
    file_ignore_patterns = {},
  }
end, { noremap = true, silent = true, desc = "find all files" })

-- Lspsaga Mappings
map("n", "<C-k>", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "goto prev" })
map("n", "<C-j>", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "goto next" })
map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "code action" })

-- Git Mappings
map("n", "<leader>gl", function()
  local gitblame = require "gitblame"
  if gitblame.is_blame_text_available() then
    gitblame.disable()
  else
    gitblame.enable()
  end
end, { desc = "Toggle blame line" })
map("n", "<leader>gg", "<CMD>LazyGit<CR>", { desc = "Git GUI" })

-- Debugging Mappings
map("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "toggle breakpoint" })
map("n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "continue" })
map("n", "<leader>dn", "<cmd>lua require'dap'.step_over()<CR>", { desc = "step over" })
map("n", "<leader>di", "<cmd>lua require'dap'.step_into()<CR>", { desc = "step into" })
map("n", "<leader>do", "<cmd>lua require'dap'.step_out()<CR>", { desc = "step out" })
