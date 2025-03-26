local snippet_trigger_character = ";"

return {
  { "L3MON4D3/LuaSnip", version = "v2.*" },
  {
    "saghen/blink.cmp",
    dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
    opts = {
      keymap = {
        preset = "super-tab",
        ["<CR>"] = { "accept", "fallback" },
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = false,
            kind_resolution = {
              enabled = false,
            },
            semantic_token_resolution = {
              enabled = false,
            },
          },
        },
        ghost_text = {
          enabled = false,
        },
        list = {
          selection = {
            auto_insert = false,
          },
        },
        menu = {
          border = "single",
          winblend = 0,
        },
        documentation = {
          auto_show_delay_ms = 50,
          update_delay_ms = 50,
          window = {
            border = "single",
            winblend = 0,
          },
        },
      },
      signature = { window = { border = "single" } },
      snippets = { preset = "luasnip" },
      sources = {
        per_filetype = {
          codecompanion = { "codecompanion" },
        },
      },
    },
  },
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      -- print(vim.inspect(opts.sources))
      opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
        default = { "lsp", "path", "snippets" },
        providers = {
          lsp = {
            transform_items = function(_, items)
              return vim.tbl_filter(function(item)
                print(item.kind)
                return item.kind ~= require("blink.cmp.types").CompletionItemKind.Snippet
              end, items)
            end,
          },
          snippets = {
            --   transform_items = function(a, items)
            --     local line = vim.api.nvim_get_current_line()
            --     local col = vim.api.nvim_win_get_cursor(0)[2]
            --     local before_cursor = line:sub(1, col)
            --     local start_pos, end_pos =
            --       before_cursor:find(snippet_trigger_character .. "[^" .. snippet_trigger_character .. "]*$")
            --     if start_pos then
            --       for _, item in ipairs(items) do
            --         if not item.trigger_text_modified then
            --           ---@diagnostic disable-next-line: inject-field
            --           item.trigger_text_modified = true
            --           item.textEdit = {
            --             newText = item.insertText or item.label,
            --             range = {
            --               start = { line = vim.fn.line(".") - 1, character = start_pos - 1 },
            --               ["end"] = { line = vim.fn.line(".") - 1, character = end_pos },
            --             },
            --           }
            --         end
            --       end
            --     end
            --     return items
            --
            --     -- local textEdits = require("blink.cmp.lib.text_edits")
            --     -- local bounds = a.get_bounds()
            --     -- print(vim.inspect(bounds))
            --     -- local line_number = bounds.line_number
            --     -- local start_col = bounds.start_col
            --     -- local trigger_col = start_col - 1
            --     -- -- local line = vim.api.nvim_get_current_line()
            --     -- -- local col = vim.api.nvim_win_get_cursor(0)[2]
            --     -- -- local before_cursor = line:sub(1, col)
            --     -- -- local start_pos, end_pos = before_cursor:find(trigger_text .. "[^" .. trigger_text .. "]*$")
            --     -- if start_col then
            --     --   for _, item in ipairs(items) do
            --     --     if not item.trigger_text_modified then
            --     --       ---@diagnostic disable-next-line: inject-field
            --     --       item.trigger_text_modified = true
            --     --       item.textEdit = textEdits.get_from_item(item)
            --     --       print("item range character " .. vim.inspect(item.textEdit.range.start.character))
            --     --       item.textEdit.range.start.character = item.textEdit.range.start.character - 2
            --     --       item.textEdit.range["end"].character = item.textEdit.range["end"].character - 2
            --     --       print("item range character after " .. vim.inspect(item.textEdit.range.start.character))
            --     --       -- item.textEdit = {
            --     --       --   newText = item.insertText or item.label,
            --     --       --   range = {
            --     --       --     start = { line = line_number, character = trigger_col },
            --     --       --     -- ["end"] = { line = vim.fn.line(".") - 1, character = end_pos },
            --     --       --   },
            --     --       -- }
            --     --     end
            --     --   end
            --     -- end
            --     -- return items
            --   end,
            should_show_items = function(ctx)
              return ctx.trigger.initial_kind ~= "trigger_character" and not require("blink.cmp").snippet_active()
            end,
          },
        },
      })

      --
      -- opts.sources.providers.snippets.override.get_trigger_characters = function(self)
      --   return { ";" }
      -- end
      return opts
    end,
  },
}
