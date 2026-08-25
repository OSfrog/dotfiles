local mason_root = vim.fn.stdpath "data" .. "/mason"
local analyzers = vim.fn.glob(mason_root .. "/share/sonarlint-analyzers/*.jar", true, true)

if #analyzers == 0 then
  vim.notify(
    "SonarLint analyzers are missing. Run :MasonInstall sonarlint-language-server and restart Neovim.",
    vim.log.levels.WARN
  )
  return nil
end
local homebrew_java = "/opt/homebrew/opt/openjdk@21/bin/java"
local java = vim.uv.fs_stat(homebrew_java) and homebrew_java or vim.fn.exepath "java"

if not vim.uv.fs_stat(java) then
  vim.notify("SonarLint requires Java 17 or newer.", vim.log.levels.WARN)
  return nil
end
local language_server = mason_root .. "/packages/sonarlint-language-server/extension/server/sonarlint-ls.jar"
if not vim.uv.fs_stat(language_server) then
  vim.notify("SonarLint language server is missing. Run :MasonInstall sonarlint-language-server.", vim.log.levels.WARN)
  return nil
end

local project_keys = {
  [vim.fs.normalize(vim.fn.expand "~/Dev/backstage")] = "Backstage",
}

local function get_token()
  local result = vim
    .system({
      "security",
      "find-generic-password",
      "-a",
      vim.env.USER,
      "-s",
      "sonarqube-neovim-token",
      "-w",
    }, { text = true })
    :wait()

  if result.code == 0 then
    return vim.trim(result.stdout)
  end
end

return {
  filetypes = {
    "css",
    "dockerfile",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "typescript",
    "typescriptreact",
    "yaml",
  },
  connected = {
    get_credentials = function()
      return get_token()
    end,
  },
  server = {
    cmd = vim.list_extend({
      java,
      "-jar",
      language_server,
      "-stdio",
      "-analyzers",
    }, analyzers),
    settings = {
      sonarlint = {
        connectedMode = {
          connections = {
            sonarqube = {
              {
                connectionId = "volvo-cars",
                serverUrl = "https://orion-sonarqube.volvocars.biz",
                disableNotifications = false,
              },
            },
          },
        },
      },
    },
    before_init = function(params, config)
      local project_key = project_keys[vim.fs.normalize(params.rootPath)]
      if project_key then
        config.settings.sonarlint.connectedMode.project = {
          connectionId = "volvo-cars",
          projectKey = project_key,
        }
      end
    end,
  },
}
