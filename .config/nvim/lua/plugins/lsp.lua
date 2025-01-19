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
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "nvim-telescope/telescope.nvim",
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
      -- keys[#keys + 1] = { "gi", vim.lsp.buf.implementation, desc = "Goto Implementation" }
      keys[#keys + 1] = { "gi", require("telescope.builtin").lsp_implementations, desc = "Goto Implementation" }
    end,
  },
}
