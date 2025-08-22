local dap_extras = require("extras.dap")

if true then
  return {}
end

return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      dap_extras.create_autocmds()

      local dap = require("lua.extras.dap")
      if not dap.adapters["chrome"] then
        dap.adapters["chrome"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = {
              require("mason-registry").get_package("js-debug-adapter"):get_install_path() .. "/js-debug/src/dapDebugServer.js",
              "${port}",
            },
          },
        }
      end
      if not dap.adapters["node-terminal"] then
        dap.adapters["node-terminal"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          cwd = vim.fn.getcwd(),
          executable = {
            command = "node",
            args = {
              require("mason-registry").get_package("js-debug-adapter"):get_install_path() .. "/js-debug/src/dapDebugServer.js",
              "${port}",
            },
          },
        }
      end
      for _, lang in ipairs({
        "typescript",
        "javascript",
        "typescriptreact",
        "javascriptreact",
      }) do
        dap.configurations[lang] = dap.configurations[lang] or {}
        table.insert(dap.configurations[lang], {
          type = "pwa-node",
          request = "attach",
          name = "Auto Attach",
          cwd = vim.fn.getcwd() .. "/packages/administration_next",
          protocol = "inspector",
          sourceMaps = true,
          __workspaceFolder = vim.fn.getcwd() .. "/packages/administration_next",
          serverReadyAction = {
            pattern = "- Local:.+(https?://.+)",
            uriFormat = "%s",
            action = "debugWithChrome",
          },
        })
        -- table.insert(dap.configurations[lang], {
        --   type = "chrome",
        --   request = "launch",
        --   name = "Launch Chrome",
        --   url = "http://localhost:3000",
        --   -- sourceMaps = true,
        -- })
        -- table.insert(dap.configurations[lang], {
        --   type = "node-terminal",
        --   request = "launch",
        --   name = "Launch Chrome",
        --   url = "http://localhost:3000",
        --   -- sourceMaps = true,
        -- })
      end
    end,
  },
  {
    "jbyuki/one-small-step-for-vimkind",
    keys = {
      {
        "<leader>dL",
        function()
          require("osv").launch({ port = 8086 })
        end,
        desc = "Launch lua adapter",
      },
    },
  },
}
