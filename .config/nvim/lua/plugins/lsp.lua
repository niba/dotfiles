return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy", -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    config = function()
      require("tiny-inline-diagnostic").setup()
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      win = {
        wo = {
          wrap = true,
        },
      },
    },
  },
  {
    "saecki/live-rename.nvim",
    opts = {
      prepare_rename = true,
      request_timeout = 1500,
      keys = {
        submit = {
          { "n", "<cr>" },
          { "v", "<cr>" },
          { "i", "<cr>" },
        },
        cancel = {
          { "n", "<esc>" },
          { "n", "q" },
        },
      },
      hl = {
        current = "LspReferenceText",
        others = "Search",
      },
    },
    keys = {
      {
        "<leader>cr",
        function()
          require("live-rename").rename({ insert = true })
        end,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "nvim-telescope/telescope.nvim",
      },
    },
    opts = {
      diagnostics = {
        --  "rachartier/tiny-inline-diagnostic.nvim" handles virtual text diagnostics
        virtual_text = false,
      },
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "disabled",
              },
            },
          },
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/snacks.nvim",
      },
    },
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      keys[#keys + 1] = { "gI", false }
      keys[#keys + 1] = { "<leader>cr", false }
      keys[#keys + 1] = { "gt", vim.lsp.buf.type_definition, desc = "Goto Type Definition" }
      keys[#keys + 1] = { "m", vim.lsp.buf.hover, desc = "Hover" }
      keys[#keys + 1] = { "gm", vim.lsp.buf.hover, desc = "Hover" }
      keys[#keys + 1] = { "gM", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" }
      keys[#keys + 1] = { "gi", Snacks.picker.lsp_implementations, desc = "Goto Implementation" }
      keys[#keys + 1] = {
        "<leader>ss",
        function()
          Snacks.picker.lsp_symbols({
            layout = { preset = "sidebar", preview = "main", layout = { position = "right" } },
          })
          -- Snacks.picker.lsp_symbols({ layout = "right" })
        end,
        desc = "LSP Symbols",
      }
      keys[#keys + 1] = {
        "<leader>sS",
        function()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = "LSP Workspace Symbols",
      }
    end,
  },
}
