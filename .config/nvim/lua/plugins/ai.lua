vim.g.copilot_enabled = false

return {
  {
    "github/copilot.vim",
  },
  {
    "franco-ruggeri/codecompanion-spinner.nvim",
    dependencies = {
      "olimorris/codecompanion.nvim",
      "nvim-lua/plenary.nvim",
    },
    opts = {
      -- log_level = "debug",
    },
  },
  {
    -- dir = "/Users/niba/Documents/Projects/open_source/claudecode.nvim",
    "coder/claudecode.nvim",
    enabled = true,
    config = true,
    keys = {
      { "<leader>aca", nil, desc = "AI/Claude Code" },
      { "<leader>acc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>acf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>acr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>acC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>acs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    },
    opts = {
      diff_opts = {
        open_in_current_tab = false,
        use_dedicated_tab = true,
      },
    },
  },
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
        auto_approve = true,
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              show_result_in_chat = true, -- Show mcp tool results in chat
              make_vars = true, -- Convert resources to #variables
              make_slash_commands = true, -- Add prompts as /slash commands
            },
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
        "<leader>ab",
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
        "<leader>ag",
        function()
          require("codecompanion").prompt("et")
        end,
        desc = "Edit and Test Workflow",
        mode = { "n", "v" },
      },
      {
        "<leader>ao",
        function()
          vim.cmd(":CodeCompanionChat")
        end,
        desc = "New Chat",
        mode = { "n", "v" },
      },
      {
        "<leader>ap",
        function()
          require("codecompanion").prompt("jarvis")
        end,
        desc = "Jarvis",
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
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            show_result_in_chat = true, -- Show mcp tool results in chat
            make_vars = true, -- Convert resources to #variables
            make_slash_commands = true, -- Add prompts as /slash commands
          },
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
          -- adapter = "anthropic",
          adapter = {
            name = "copilot",
            model = "claude-sonnet-4",
          },
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
      prompt_library = {
        ["Jarvis"] = {
          strategy = "chat",
          description = "Prompt the LLM from Neovim",
          opts = {
            index = 12,
            is_slash_cmd = false,
            short_name = "jarvis",
          },
          prompts = {
            {
              role = "system",
              content = function(context)
                -- vim.g.codecompanion_auto_tool_mode = true

                -- return string.format([[Use @mcp for context7 searches based on these keywords:
                --
                --   - "effect" → search context7 "Effect (llmstxt)" library
                --   - "jj" → search context7 "jj" library
                --   - "cloudflare workers" → search context7 "cloudflare workers" library
                --   - "tanstack router" -> search context7 "tanstack router" library
                --   - "tanstack form" -> search context7 "tanstack form" library
                --   - "tanstack query" -> search context7 "tanstack query" library
                --
                -- ]])
                return string.format([[Use @mcp for context7 searches based on these keywords:

                  - "jj" → search context7 "jj" library  
                  - "cloudflare workers" → search context7 "cloudflare workers" library
                  - "tanstack router" -> search context7 "tanstack router" library
                  - "tanstack form" -> search context7 "tanstack form" library
                  - "tanstack query" -> search context7 "tanstack query" library

                  for any question related to effect try to use effect-docs tool and search context7 "Effect (llmstxt)" library 

                ]])
              end,
              opts = {
                visible = false,
              },
            },
            {
              role = "user",
              content = function(context)
                return ""
              end,
            },
          },
        },
      },
    },
  },
}
