local enabled = false

local prepare_data_for_json = function(data)
  if type(data) == "table" then
    return data.body
  end
  local find_json_start = string.find(data, "{") or 1
  return string.sub(data, find_json_start)
end

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
            handlers = {
              chat_output = function(self, data)
                local output = {}

                if data and data ~= "" then
                  local data_mod = prepare_data_for_json(data)
                  local ok, json = pcall(vim.json.decode, data_mod, { luanil = { object = true } })

                  if ok and json.choices and #json.choices > 0 then
                    local choice = json.choices[1]
                    local delta = (self.opts and self.opts.stream) and choice.delta or choice.message

                    if delta then
                      if delta.role then
                        output.role = delta.role
                      else
                        output.role = nil
                      end

                      output.content = ""

                      -- ADD THINKING OUTPUT
                      if delta.reasoning_content then
                        output.content = delta.reasoning_content
                      end

                      if delta.content then
                        output.content = output.content .. delta.content
                      end

                      return {
                        status = "success",
                        output = output,
                      }
                    end
                  end
                end
              end,
            },
          })
        end,
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            schema = {
              model = {
                -- default = "gemini-2.0-flash-exp",
                default = "gemini-2.0-flash-thinking-exp",
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
          adapter = "anthropic",
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
