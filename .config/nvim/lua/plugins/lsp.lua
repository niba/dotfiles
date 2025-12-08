return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy", -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    config = function()
      require("tiny-inline-diagnostic").setup()
      vim.diagnostic.config({ virtual_text = false })
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
    keys = {
      {
        "[n",
        function()
          if require("trouble").is_open() then
            require("trouble").prev({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous Trouble/Quickfix Item",
      },
      {
        "]n",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next Trouble/Quickfix Item",
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
        desc = "Rename",
      },
    },
  },
  -- {
  --   "neovim/nvim-lspconfig",
  --   config = function()
  --     require("lspconfig").nushell.setup({
  --       cmd = { "nu", "--lsp" },
  --       filetypes = { "nu" },
  --       root_dir = function()
  --         local lazyvimRoot = require("lazyvim.util.root")
  --         return lazyvimRoot.git()
  --       end,
  --       single_file_support = true,
  --     })
  --   end,
  -- },
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        --  "rachartier/tiny-inline-diagnostic.nvim" handles virtual text diagnostics
        virtual_text = false,
      },
      servers = {
        eslint = {
          settings = {
            format = false,
            workingDirectories = { mode = "auto" }, -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
          },
          flags = {
            allow_incremental_sync = false,
            debounce_text_changes = 1000,
          },
          -- keys = {
          --   {
          --     "<leader>ef",
          --     ":EslintFixAll<CR>",
          --     desc = desc("Fix all"),
          --   },
          -- },
        },
        harper_ls = {
          enabled = false,
          settings = {
            ["harper-ls"] = {
              linters = {
                SentenceCapitalization = false,
              },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Disable",
                showWord = "Disable",
                keywordSnippet = "Disable",
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
      keys[#keys + 1] = { "gy", false }
      keys[#keys + 1] = { "<leader>cr", false }
      keys[#keys + 1] = { "gt", vim.lsp.buf.type_definition, desc = "Goto Type Definition" }
      keys[#keys + 1] = {
        "m",
        function()
          return vim.lsp.buf.hover()
        end,
        desc = "Hover",
      }
      keys[#keys + 1] = {
        "gm",
        function()
          return vim.lsp.buf.hover()
        end,
        desc = "Hover",
      }
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
