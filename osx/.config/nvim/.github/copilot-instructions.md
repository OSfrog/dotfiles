# Copilot instructions for `osx/.config/nvim`

## Build, test, and lint commands

- **Neovim version**: this config expects **Neovim 0.9+** (from repo README).
- **Install/update plugins**: `nvim --headless "+Lazy! sync" +qa` (interactive alternative: `:Lazy`).
- **Lint/format Lua config**: `stylua init.lua lua`
- **Full smoke check (no dedicated test suite exists)**: `nvim --headless "+checkhealth" +qa`
- **Single-target smoke check**: `nvim --headless "+lua require('configs.lspconfig')" +qa`

## Core stack (authoritative)

- **Framework**: **NvChad** is the Neovim framework/base distribution (`NvChad/NvChad` in `init.lua`).
- **Plugin/package manager**: **lazy.nvim** manages plugin install/update/lazy-loading (`lazy.setup(...)` + `:Lazy` workflow).
- **LSP/tool installer**: **Mason** (`mason.nvim` + `mason-lspconfig.nvim`) manages LSP server installation and activation policy.
- **LSP client configuration**: **nvim-lspconfig** + NvChad defaults provide runtime LSP setup.
- **Formatter orchestration**: **conform.nvim** handles format-on-save and formatter selection by filetype.

## High-level architecture

- Startup flow in `init.lua` is order-sensitive:
  1. Set global runtime values (`mapleader`, base46 cache path)
  2. Bootstrap `lazy.nvim`
  3. Load `NvChad/NvChad` (branch `v2.5`) and then local plugin specs from `lua/plugins/init.lua`
  4. Load generated base46 cache files (`defaults`, `statusline`, `syntax`, `treesitter`)
  5. Load autocmds and defer mappings with `vim.schedule(...)`
- NvChad theme/UI is split across `lua/chadrc.lua` (base46, statusline, nvdash, terminal UI) and `lua/highlights.lua` (highlight overrides/additions).
- `lua/configs/lazy.lua` controls lazy.nvim UI/performance (including disabled built-in runtime plugins).
- Plugin specs live in `lua/plugins/init.lua`; implementation details are delegated to `lua/configs/*.lua` and pulled in via `opts`/`config`.
- LSP architecture is layered:
  - base defaults from `nvchad.configs.lspconfig`
  - server install/enable policy in `lua/configs/lspconfig.lua` via `mason-lspconfig` (`ensure_installed`, `automatic_enable.exclude`)
  - explicit force-disable of excluded servers and explicit enable of Copilot LSP
- AI tooling is intentionally composed across files:
  - `copilot.lua` plugin config (`lua/plugins/init.lua`) controls inline suggestion behavior
  - `blink.cmp` behavior (`lua/configs/blink.lua`) prioritizes Copilot accept-on-`<Tab>`
  - chat/CLI surfaces are exposed via `CopilotChat` and `sidekick.nvim` keymaps in `lua/mappings.lua`
- Debugging flow is centralized in `lua/configs/dap.lua`: it loads project `launch.json`, wires `pwa-node` adapter from Mason's js-debug-adapter path, and opens/closes DAP UI through listener hooks.

## Key conventions in this codebase

- Keep the **NvChad extension pattern**: extend defaults rather than replacing them (`require "nvchad.options"`, `require "nvchad.mappings"`, and `require("nvchad.configs.lspconfig").defaults()` first).
- Put plugin-specific config in `lua/configs/<plugin>.lua`, and wire it from `lua/plugins/init.lua` via `opts = require(...)` or `config = function() require(...) end`.
- Prefer lazy-loading via `event`, `cmd`, and `dependencies` in plugin specs; avoid eager loading unless startup-critical.
- For optional plugin configs, follow the existing guarded pattern:
  - `local ok, mod = pcall(require, "...")`
  - `if not ok then return end`
- LSP setup convention: Mason manages installs, `automatic_enable` is used with explicit excludes, and excluded servers are also force-disabled via `vim.lsp.enable(excluded, false)`.
- Formatting is centralized in `lua/configs/conform.lua` with explicit formatter order (`prettierd` then `prettier`, `stop_after_first = true`) and format-on-save enabled.
