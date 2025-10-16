-- lua/config/dap.lua
local M = {}

function M.setup()
  local dap = require "dap"
  local dapui = require "dapui"
  local dap_vt = require "nvim-dap-virtual-text"
  local dap_utils = require "dap.utils"

  -- ╭──────────────────────────────────────────────────────────╮
  -- │ DAP Virtual Text Setup                                   │
  -- ╰──────────────────────────────────────────────────────────╯
  dap_vt.setup {
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = false,
    show_stop_reason = true,
    commented = false,
    only_first_definition = true,
    all_references = false,
    filter_references_pattern = "<module",
    virt_text_pos = "eol",
    all_frames = false,
    virt_lines = false,
    virt_text_win_col = nil,
  }

  -- ╭──────────────────────────────────────────────────────────╮
  -- │ DAP UI Setup                                             │
  -- ╰──────────────────────────────────────────────────────────╯
  dapui.setup {
    icons = { expanded = "▾", collapsed = "▸" },
    mappings = {
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      edit = "e",
      repl = "r",
      toggle = "t",
    },
    expand_lines = vim.fn.has "nvim-0.7",
    layouts = {
      {
        elements = { { id = "scopes", size = 0.25 }, "breakpoints", "watches" },
        size = 40,
        position = "left",
      },
      {
        elements = { "repl", "console" },
        size = 0.25,
        position = "bottom",
      },
    },
    floating = {
      max_height = nil,
      max_width = nil,
      border = "single",
      mappings = { close = { "q", "<Esc>" } },
    },
    windows = { indent = 1 },
    render = { max_type_length = nil },
  }

  -- ╭──────────────────────────────────────────────────────────╮
  -- │ DAP Setup                                                │
  -- ╰──────────────────────────────────────────────────────────╯
  dap.set_log_level "TRACE"

  -- Automatically open/close UI
  dap.listeners.before.attach["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.launch["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end

  vim.g.dap_virtual_text = true

  -- ╭──────────────────────────────────────────────────────────╮
  -- │ Icons                                                    │
  -- ╰──────────────────────────────────────────────────────────╯
  vim.fn.sign_define("DapBreakpoint", { text = "🔵", texthl = "", linehl = "", numhl = "" })
  vim.fn.sign_define("DapBreakpointRejected", { text = "🔴", texthl = "", linehl = "", numhl = "" })
  vim.fn.sign_define("DapConditionalBreakpoint", { text = "🟡", texthl = "", linehl = "", numhl = "" })
  vim.fn.sign_define("DapStopped", { text = "🟢", texthl = "", linehl = "", numhl = "" })

  -- ╭──────────────────────────────────────────────────────────╮
  -- │ Adapters                                                 │
  -- ╰──────────────────────────────────────────────────────────╯
  dap.adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "node",
      args = { vim.fn.stdpath "data" .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
    },
  }

  dap.adapters["pwa-chrome"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "node",
      args = { vim.fn.stdpath "data" .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
    },
  }

  -- ╭──────────────────────────────────────────────────────────╮
  -- │ Configurations                                           │
  -- ╰──────────────────────────────────────────────────────────╯
  local exts = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "svelte" }

  for _, ext in ipairs(exts) do
    dap.configurations[ext] = {
      {
        type = "pwa-chrome",
        request = "launch",
        name = 'Launch Chrome with "localhost"',
        url = function()
          local co = coroutine.running()
          return coroutine.create(function()
            vim.ui.input({ prompt = "Enter URL: ", default = "http://localhost:3000" }, function(url)
              if url and url ~= "" then
                coroutine.resume(co, url)
              end
            end)
          end)
        end,
        webRoot = "${workspaceFolder}",
        protocol = "inspector",
        sourceMaps = true,
        userDataDir = false,
        skipFiles = { "<node_internals>/**", "node_modules/**", "${workspaceFolder}/node_modules/**" },
        resolveSourceMapLocations = {
          "${webRoot}/*",
          "${webRoot}/apps/**/**",
          "${workspaceFolder}/apps/**/**",
          "${webRoot}/packages/**/**",
          "${workspaceFolder}/packages/**/**",
          "${workspaceFolder}/*",
          "!**/node_modules/**",
        },
      },
      {
        type = "pwa-node",
        request = "launch",
        name = "Debug TS file",
        cwd = vim.fn.getcwd(),
        runtimeExecutable = "node",
        runtimeArgs = {
          "--loader",
          "/Users/tommy/.local/share/nvm/v23.11.0/lib/node_modules/ts-node/esm.mjs",
          "--enable-source-maps",
        },
        args = { "${file}" },
        sourceMaps = true,
        protocol = "inspector",
        console = "integratedTerminal",
        skipFiles = { "<node_internals>/**", "node_modules/**" },
        env = { NODE_NO_WARNINGS = "1" },
      },
      {
        name = "Next.js: debug server-side (pwa-node)",
        type = "pwa-node",
        request = "attach",
        port = 9231,
        skipFiles = { "<node_internals>/**", "node_modules/**" },
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach Program (pwa-node, select pid)",
        cwd = vim.fn.getcwd(),
        processId = dap_utils.pick_process,
        skipFiles = { "<node_internals>/**" },
      },
      -- Add other configurations from your original snippet here as needed
    }
  end
end

return M
