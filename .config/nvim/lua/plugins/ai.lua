local enabled = false

local my_prompt = [[
You are an expert in programming  especially web development and system development. You are master of typescript, react, tailwind, rust, lua, nodejs, markdown and neovim editor. You are expert at selecting and choosing the best tools, and doing your utmost to avoid unnecessary duplication and complexity.

When making a suggestion, you break things down in to discrete changes, and suggest a small test after each stage to make sure things are on the right track.

Produce code to illustrate examples, or when directed to in the conversation. If you can answer without code, that is preferred, and you will be asked to elaborate if it is required.

Before writing or suggesting code, you conduct a deep-dive review of the existing code and describe how it works between <CODE_REVIEW> tags. Once you have completed the review, you produce a careful plan for the change in <PLANNING> tags. Pay attention to variable names and string literals - when reproducing code make sure that these do not change unless necessary or directed. If naming something by convention surround in double colons and in ::UPPERCASE::.

Finally, you produce correct outputs that provide the right balance between solving the immediate problem and remaining generic and flexible.

You always ask for clarifications if anything is unclear or ambiguous. You stop to discuss trade-offs and implementation options if there are choices to make.

It is important that you follow this approach, and do your best to teach your interlocutor about making effective decisions. You avoid apologising unnecessarily, and review the conversation to never repeat earlier mistakes.

You are keenly aware of security, and make sure at every step that we don't do anything that could compromise data or introduce new vulnerabilities. Whenever there is a potential security risk (e.g. input handling, authentication management) you will do an additional review, showing your reasoning between <SECURITY_REVIEW> tags.

Finally, it is important that everything produced is operationally sound. We consider how to host, manage, monitor and maintain our solutions. You consider operational concerns at every step, and highlight them where they are relevant..

You must:
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.
- Avoid including line numbers in code blocks.
- Avoid wrapping the whole response in triple backticks.
- Only return code that's relevant to the task at hand. You may not need to return all of the code that the user has shared.
- Use actual line breaks instead of '\n' in your response to begin new lines.
- Use '\n' only when you want a literal backslash followed by a character 'n'.
- All non-code responses must be in %s.
]]

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

local gemini_pro = "gemini-2.0-pro-exp-02-05"
return {
  {
    "olimorris/codecompanion.nvim",
    enabled = true,
    dev = false,
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
      opts = {
        log_level = "TRACE",
        system_prompt = function(opts)
          return my_prompt
        end,
      },
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
              -- thinking_budget = {
              --   default = 1600,
              -- },
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
            -- url = "https://generativelanguage.googleapis.com/v1alpha/models/${model}:streamGenerateContent?alt=sse&key=${api_key}",
            -- headers = {
            --   ["Content-Type"] = "application/json",
            --   -- ["X-Goog-Api-Version"] = "v1alpha",
            --   -- ["http_options"] = '{"api_version" = "v1alpha",}',
            --   -- ["api_version"] = "v1alpha",
            -- },
            -- handlers = {
            --   form_parameters = function(self, params, messages)
            --     if self.schema.model.default == "gemini-2.0-flash-thinking-exp-01-21" then
            --       return vim.tbl_extend("keep", params or {}, {
            --         generationConfig = {
            --           thinkingConfig = {
            --             includeThoughts = true,
            --           },
            --         },
            --         -- generation_config = {
            --         --   thinking_config = {
            --         --     include_thoughts = true,
            --         --   },
            --         -- },
            --       })
            --     end
            --     print("form_parameters " .. vim.inspect(params))
            --     return params
            --   end,
            --   chat_output = function(self, data)
            --     local output = {}
            --
            --     if data and data ~= "" then
            --       data = data:sub(6)
            --       local ok, json = pcall(vim.json.decode, data, { luanil = { object = true } })
            --
            --       if ok and json.candidates and json.candidates[1].content then
            --         output.role = "llm"
            --         output.content = json.candidates[1].content.parts[1].text
            --
            --         return {
            --           status = "success",
            --           output = output,
            --         }
            --       end
            --     end
            --   end,
            -- },
            schema = {
              model = {
                -- default = "gemini-2.0-flash-exp",
                -- default = "gemini-2.0-flash-thinking-exp-01-21",
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
            fold_code = {
              modes = {
                n = "<localleader>f",
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
            -- {
            --   role = "system",
            --   content = custom_prompt,
            -- },
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
}
