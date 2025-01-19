local enabled = false

local custom_prompt =
  [[You are an expert in Web development, including CSS, JavaScript, TypeScript, React, Tailwind, Node.JS and Markdown, you are also expert in system programming using rust and expert in lua and neovim editor. You are expert at selecting and choosing the best tools, and doing your utmost to avoid unnecessary duplication and complexity.

When making a suggestion, you break things down in to discrete changes, and suggest a small test after each stage to make sure things are on the right track.

Produce code to illustrate examples, or when directed to in the conversation. If you can answer without code, that is preferred, and you will be asked to elaborate if it is required.

Before writing or suggesting code, you conduct a deep-dive review of the existing code and describe how it works between <CODE_REVIEW> tags. Once you have completed the review, you produce a careful plan for the change in <PLANNING> tags. Pay attention to variable names and string literals - when reproducing code make sure that these do not change unless necessary or directed. If naming something by convention surround in double colons and in ::UPPERCASE::.

Finally, you produce correct outputs that provide the right balance between solving the immediate problem and remaining generic and flexible.

You always ask for clarifications if anything is unclear or ambiguous. You stop to discuss trade-offs and implementation options if there are choices to make.

It is important that you follow this approach, and do your best to teach your interlocutor about making effective decisions. You avoid apologising unnecessarily, and review the conversation to never repeat earlier mistakes.

You are keenly aware of security, and make sure at every step that we don't do anything that could compromise data or introduce new vulnerabilities. Whenever there is a potential security risk (e.g. input handling, authentication management) you will do an additional review, showing your reasoning between <SECURITY_REVIEW> tags.

Finally, it is important that everything produced is operationally sound. We consider how to host, manage, monitor and maintain our solutions. You consider operational concerns at every step, and highlight them where they are relevant.]]

return {
  {
    "frankroeder/parrot.nvim",
    enabled = false,
    tag = "v0.3.2",
    dependencies = { "ibhagwan/fzf-lua", "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>aa",
        "<cmd>PrtChatToggle vsplit<cr>",
        desc = "Toggle Chat",
        mode = { "n", "v" },
      },
    },
    config = function()
      require("parrot").setup({
        toggle_target = "vsplit",
        providers = {
          pplx = {
            api_key = os.getenv("PERPLEXITY_API_KEY"),
            -- OPTIONAL
            -- gpg command
            -- api_key = { "gpg", "--decrypt", vim.fn.expand("$HOME") .. "/pplx_api_key.txt.gpg"  },
            -- macOS security tool
            -- api_key = { "/usr/bin/security", "find-generic-password", "-s pplx-api-key", "-w" },
          },
          openai = {
            api_key = os.getenv("OPENAI_API_KEY"),
          },
          anthropic = {
            api_key = os.getenv("ANTHROPIC_API_KEY"),
          },
          mistral = {
            api_key = os.getenv("MISTRAL_API_KEY"),
          },
        },
        --       agents = {
        -- chat = {
        --
        --         },
        --         command = {
        --
        --         }
        --       },
        hooks = {
          Explain = function(prt, params)
            local template = [[
        Your task is to take the code snippet from {{filename}} and explain it with gradually increasing complexity.
        Break down the code's functionality, purpose, and key components.
        The goal is to help the reader understand what the code does and how it works.

        ```{{filetype}}
        {{selection}}
        ```

        Use the markdown format with codeblocks and inline code.
        Explanation of the code above:
        ]]
            local agent = prt.get_chat_agent()
            prt.logger.info("Explaining selection with agent: " .. agent.name)
            prt.Prompt(params, prt.ui.Target.new, nil, agent.model, template, agent.system_prompt, agent.provider)
          end,
          CompleteFullContext = function(prt, params)
            local template = [[
          I have the following code from {{filename}}:

          ```{{filetype}}
          {{filecontent}}
          ```

          Please look at the following section specifically:
          ```{{filetype}}
          {{selection}}
          ```

          Please finish the code above carefully and logically.
          Respond just with the snippet of code that should be inserted.
          ]]
            local agent = prt.get_command_agent()
            prt.Prompt(params, prt.ui.Target.append, nil, agent.model, template, agent.system_prompt, agent.provider)
          end,
        },
        -- agents = {
        --   chat = {
        --     {
        --       name = "CodeLlama",
        --       model = { model = "codellama", temperature = 1.5, top_p = 1, num_ctx = 8192, min_p = 0.05 },
        --       system_prompt = "Help me!",
        --       provider = "ollama",
        --     }
        --   }
        -- },
      })
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    enabled = true,
    event = "BufEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim", -- Optional
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
        "<leader>ai",
        function()
          require("codecompanion").prompt("terminal")
        end,
        desc = "Terminal",
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
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            schema = {
              model = {
                default = "claude-3-5-sonnet-20241022",
              },
              max_tokens = {
                default = 8192,
              },
            },
          })
        end,
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            schema = {
              model = {
                default = "gemini-2.0-flash-exp",
              },
              max_tokens = {
                default = 8192,
              },
            },
          })
        end,
      },
      display = {
        chat = {
          show_settings = true,
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
          adapter = "gemini",
          slash_commands = {
            -- ["help"] = {
            --   callback = "helpers.slash_commands.help",
            --   description = "Insert content from help tags",
            --   opts = {
            --     contains_code = true,
            --     provider = "mini_pick",
            --   },
            -- },
            -- ["file"] = {
            --   callback = "helpers.slash_commands.file",
            --   description = "Share a file's contents with the LLM",
            --   opts = {
            --     contains_code = true,
            --     max_lines = 1000,
            --     provider = "mini_pick", -- telescope | or: mini_pick
            --   },
            -- },
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
                n = "<C-x>",
                i = "<C-x>",
              },
            },
            clear = {
              modes = {
                n = "<localleader>x",
              },
            },
            codeblock = {
              modes = {
                n = "<localleader>c",
              },
            },
            change_adapter = {
              modes = {
                n = "<localleader>A",
              },
            },
            fold_code = {
              modes = {
                n = "<localleader>z",
              },
            },
            debug = {
              modes = {
                n = "<localleader>d",
              },
            },
          },
        },
      },
      prompt_library = {
        ["Explain"] = {
          opts = {
            mapping = "<leader>ae",
          },
        },
        ["Unit Tests"] = {
          opts = {
            mapping = "<leader>at",
          },
        },
        ["Fix code"] = {
          opts = {
            mapping = "<leader>af",
          },
        },
        ["Buffer selection"] = {
          opts = {
            mapping = "<leader>ab",
          },
        },
        ["Explain LSP Diagnostics"] = {
          opts = {
            mapping = "<leader>al",
          },
        },
        ["Generate a Commit Message"] = {
          opts = {
            mapping = "<leader>aM",
          },
        },

        ["Terminal"] = {
          strategy = "chat",
          description = "Help with terminal commands",
          opts = {
            index = 10,
            default_prompt = true,
            modes = { "n", "v" },
            short_name = "terminal",
            user_prompt = false,
            auto_submit = false,
          },
          prompts = {
            {
              role = "system",
              content = function(context)
                return "I want you to act as an expert in writing terminal commands that will work for my current shell "
                  .. os.getenv("SHELL")
                  .. ""
              end,
            },
            {
              role = "user",
              content = "\n \n",
            },
          },
        },
        ["Jarvis"] = {
          strategy = "chat",
          description = "Jarvis",
          opts = {
            index = 10,
            default_prompt = false,
            modes = { "n", "v" },
            short_name = "jarvis",
            mapping = "<leader>ap",
            user_prompt = false,
            auto_submit = false,
          },
          prompts = {
            {
              role = "system",
              content = custom_prompt,
              -- content = function(context)
              --   return custom_prompt
              -- end,
            },
            {
              role = "user",
              content = "\n \n",
            },
          },
        },
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = false,
    opts = {
      selection = function(source)
        local select = require("CopilotChat.select")
        return select.visual(source) or select.line(source)
      end,
    },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    enabled = false,
    build = ":Copilot auth",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = enabled,
          auto_refresh = true,
        },
        suggestion = {
          enabled = enabled,
          auto_trigger = true,
          accept = false, -- disable built-in keymapping
        },
      })
    end,
  },

  -- copilot status in lualine
  -- this is taken from the copilot lazyvim extras at:
  -- https://www.lazyvim.org/plugins/extras/coding.copilot
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      local Util = require("lazyvim.util")
      local colors = {
        [""] = Util.ui.fg("Special"),
        ["Normal"] = Util.ui.fg("Special"),
        ["Warning"] = Util.ui.fg("DiagnosticError"),
        ["InProgress"] = Util.ui.fg("DiagnosticWarn"),
      }
      table.insert(opts.sections.lualine_x, 2, {
        function()
          local icon = require("lazyvim.config").icons.kinds.Copilot
          local status = require("copilot.api").status.data
          return icon .. (status.message or "")
        end,
        cond = function()
          local ok, clients = pcall(vim.lsp.get_active_clients, { name = "copilot", bufnr = 0 })
          return ok and #clients > 0
        end,
        color = function()
          if not package.loaded["copilot"] then
            return
          end
          local status = require("copilot.api").status.data
          return colors[status.status] or colors[""]
        end,
      })
    end,
  },
}
