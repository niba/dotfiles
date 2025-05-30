return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
    },
    -- comment the following line to ensure hub will be ready at the earliest
    cmd = "MCPHub", -- lazy load by default
    build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
    -- uncomment this if you don't want mcp-hub to be available globally or can't use -g
    -- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
    config = function()
      require("mcphub").setup({
        extensions = {
          codecompanion = {
            -- Show the mcp tool result in the chat buffer
            show_result_in_chat = false,
            -- Make chat #variables from MCP server resources
            make_vars = true,
          },
        },
      })
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    dev = false,
    event = "BufEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      {
        "<leader>aa",
        "<cmd>CodeCompanionChat Toggle<cr>",
        desc = "Toggle Chat",
        mode = { "n", "v" },
      },
      {
        "<leader>ao",
        "<cmd>CodeCompanionActions<cr>",
        desc = "Options",
        mode = { "n", "v" },
      },
      {
        "<leader>as",
        "<cmd>CodeCompanionChat Add<cr>",
        desc = "Add visual selected",
        mode = { "v" },
      },
      {
        "<leader>ae",
        function()
          require("codecompanion").prompt("explain")
        end,
        desc = "Explain",
        mode = { "n", "v" },
      },
      {
        "<leader>at",
        function()
          require("codecompanion").prompt("tests")
        end,
        desc = "Test",
        mode = { "n", "v" },
      },
      {
        "<leader>af",
        function()
          require("codecompanion").prompt("fix")
        end,
        desc = "Fix",
        mode = { "n", "v" },
      },
      {
        "<leader>al",
        function()
          require("codecompanion").prompt("lsp")
        end,
        desc = "Lsp",
        mode = { "n", "v" },
      },
      {
        "<leader>am",
        function()
          require("codecompanion").prompt("commit")
        end,
        desc = "Commit",
        mode = { "n", "v" },
      },
      {
        "<leader>ai",
        function()
          require("codecompanion").prompt("cw")
        end,
        desc = "Code Workflow",
        mode = { "n", "v" },
      },
      {
        "<leader>ap",
        function()
          vim.cmd(":CodeCompanionChat")
        end,
        desc = "New Chat",
        mode = { "n", "v" },
      },
    },
    opts = {
      adapters = {
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            schema = {
              model = {
                default = "o3-mini-2025-01-31",
              },
              max_tokens = {
                default = 16384,
              },
            },
          })
        end,
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            schema = {
              -- model = {
              --   default = "claude-3-7-sonnet-20250219",
              -- },
              max_tokens = {
                default = 8192,
              },
              extended_thinking = {
                default = false,
              },
              thinking_budget = {
                default = 1600,
              },
              temperature = {
                default = 0,
              },
            },
          })
        end,
        deepseek = function()
          return require("codecompanion.adapters").extend("deepseek", {
            env = {
              api_key = "DEEPSEEK_API_KEY",
            },
            schema = {
              model = {
                default = "deepseek-reasoner",
              },
              temperature = {
                default = 0,
              },
            },
          })
        end,
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            schema = {
              model = {
                default = "gemini-2.5-pro-exp-03-25",
              },
              max_tokens = {
                default = 8192,
              },
              temperature = {
                default = 0,
              },
            },
          })
        end,
      },
      display = {
        chat = {
          show_settings = false,
        },
      },
      strategies = {
        agent = {
          adapter = "anthropic",
        },
        inline = {
          adapter = "anthropic",
        },
        chat = {
          tools = {
            ["mcp"] = {
              callback = function()
                return require("mcphub.extensions.codecompanion")
              end,
              description = "Call tools and resources from the MCP Servers",
              opts = {
                requires_approval = true,
              },
            },
          },
          adapter = "anthropic",
          keymaps = {
            completion = {
              modes = {
                i = "<C-f>",
              },
            },
            regenerate = {
              modes = {
                n = "<localleader>r",
              },
            },
            close = {
              modes = {
                n = "<localleader>d",
                i = "<C-S-x>",
              },
            },
            clear = {
              modes = {
                n = "<localleader>x",
              },
            },
            yank_code = {
              modes = {
                n = "<localleader>y",
              },
            },
            pin = {
              modes = {
                n = "<localleader>p",
              },
            },
            watch = {
              modes = {
                n = "<localleader>w",
              },
            },
            codeblock = {
              modes = {
                n = "<localleader>c",
              },
            },
            change_adapter = {
              modes = {
                n = "<localleader>a",
              },
            },
            fold_code = {
              modes = {
                n = "<localleader>z",
              },
            },
            debug = {
              modes = {
                n = "<localleader>l",
              },
            },
          },
        },
      },
    },
  },
}
