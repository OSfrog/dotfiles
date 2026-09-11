local M = {}

--- Opens a file in Diffview, focusing on the specified file
---@param filepath string
---@param root? string
function M.open_file(filepath, root)
  local ok, diffview = pcall(require, "diffview")
  if not ok then
    -- Try loading via lazy.nvim if not yet loaded
    pcall(require("lazy").load, { plugins = { "diffview.nvim" } })
    ok, diffview = pcall(require, "diffview")
    if not ok then
      vim.notify("diffview.nvim is not installed", vim.log.levels.ERROR)
      return
    end
  end

  local lib = require "diffview.lib"
  local current_view = lib.get_current_view()
  if current_view then
    diffview.close()
  end

  local target = filepath
  if root and vim.startswith(filepath, root .. "/") then
    target = filepath:sub(#root + 2)
  end

  diffview.open { "--selected-file=" .. target }
end

--- Opens a quickfix list with unstaged Git files
function M.open()
  local root_result = vim.system({ "git", "rev-parse", "--show-toplevel" }, { text = true }):wait()
  if root_result.code ~= 0 then
    vim.notify("Not inside a Git repository", vim.log.levels.ERROR)
    return
  end

  local root = vim.trim(root_result.stdout)
  local commands = {
    { "git", "diff", "--name-only", "--diff-filter=ACMRTUXB", "-z" },
    { "git", "ls-files", "--others", "--exclude-standard", "-z" },
  }
  local files = {}

  for _, command in ipairs(commands) do
    local result = vim.system(command, { cwd = root }):wait()
    if result.code ~= 0 then
      vim.notify(vim.trim(result.stderr or "Failed to list Git changes"), vim.log.levels.ERROR)
      return
    end

    for _, file in ipairs(vim.split(result.stdout or "", "\0", { plain = true, trimempty = true })) do
      files[file] = true
    end
  end

  local items = {}
  for file in vim.spairs(files) do
    items[#items + 1] = {
      filename = root .. "/" .. file,
      lnum = 1,
    }
  end

  if #items == 0 then
    vim.notify("No unstaged Git files", vim.log.levels.INFO)
    return
  end

  vim.fn.setqflist({}, " ", {
    title = "Unstaged Git files",
    context = { type = "diffview_git_unstaged", root = root },
    items = items,
  })

  vim.cmd.copen()
end

return M
