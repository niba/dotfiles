return {
  {
    "dmmulroy/ts-error-translator.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    event = "BufEnter",
    config = function()
      require("ts-error-translator").setup()
    end,
  },
  {
    "dmmulroy/tsc.nvim",
    opts = {
      auto_open_qflist = true,
      use_trouble_qflist = true,
      use_diagnostics = false,
    },
    keys = {
      { "<leader>cp", "<cmd>TSC<cr>", desc = "Check project" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },

      servers = {
        ts_ls = {
          enabled = false,
        },
        vtsls = {
          settings = {
            complete_function_calls = false,
            vtsls = {
              autoUseWorkspaceTsdk = true,
              javascript = {
                updateImportsOnFileMove = { enabled = "always" },
                suggest = {
                  completeFunctionCalls = {
                    enabled = false,
                  },
                  classMemberSnippets = {
                    enabled = false,
                  },
                },
              },
              typescript = {
                updateImportsOnFileMove = { enabled = "always" },
                tsserver = {
                  maxTsServerMemory = 8192,
                },
                suggest = {
                  classMemberSnippets = {
                    enabled = false,
                  },
                  completeFunctionCalls = {
                    enabled = false,
                  },
                  objectLiteralMethodSnippets = {
                    enabled = false,
                  },
                },
              },
            },
          },
          -- fix finding typescript in monorepo
          root_dir = function()
            local lazyvimRoot = require("lazyvim.util.root")
            return lazyvimRoot.git()
          end,
        },
      },
    },
  },
}
