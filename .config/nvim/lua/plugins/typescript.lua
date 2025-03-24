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
            typescript = {
              tsserver = {
                maxTsServerMemory = 8192,
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
