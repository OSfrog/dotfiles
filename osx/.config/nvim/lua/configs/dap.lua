local has_dap, dap = pcall(require, "dap")
if not has_dap then
  return
end

local has_dapui, dapui = pcall(require, "dapui")
if not has_dapui then
  return
end

local has_dap_virtual_text, dap_virtual_text = pcall(require, "nvim-dap-virtual-text")
if not has_dap_virtual_text then
  return
end

dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    args = { vim.fn.stdpath "data" .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
  },
}

for _, lang in ipairs { "javascript", "javascriptreact", "typescript", "typescriptreact" } do
  dap.configurations[lang] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Backstage Backend",
      program = "${file}",
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      runtimeArgs = { "start-backend" },
      runtimeExecutable = "yarn",
      skipFiles = { "<node_internals>/**" },
    },
  }
end

require("dapui").setup()

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
  dap_virtual_text.refresh()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
  dap_virtual_text.refresh()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
  dap_virtual_text.refresh()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
  dap_virtual_text.refresh()
end
