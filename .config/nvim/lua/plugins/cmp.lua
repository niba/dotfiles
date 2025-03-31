local snippets_win = {
  snippets = 4,
  lsp = 3,
  path = 2,
  buffer = 1,
}

local lang_patterns = { tsx = { "**/typescript.json", "**/react-ts.json", "**/next-ts.json" } }

return {
  {
    "echasnovski/mini.snippets",
    -- use luasnip, better snippet engine
    enabled = false,
    keys = {
      {
        "<leader>ss",
        function()
          require("mini.snippets").expand()
        end,
        desc = "Search snippet",
      },
    },
    opts = function(_, opts)
      local mini_snippets = require("mini.snippets")

      opts.snippets = {
        mini_snippets.gen_loader.from_file("~/.config/nvim/snippets/global.json"),
        mini_snippets.gen_loader.from_lang({ lang_patterns = lang_patterns }),
      }

      opts.mappings = {
        -- mini snippets allow you to toggle modes during snippet completion
        -- if you want to go to normal mode during snippets completion then comment stop mapping
        stop = "<esc>",
        jump_next = "",
        jump_prev = "",
      }

      return opts
    end,
  },
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "super-tab",
        ["<CR>"] = { "accept", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      },
      fuzzy = {
        max_typos = function(keyword)
          return 0
        end,
        sorts = {
          function(a, b)
            if a.exact and b.exact then
              -- 14 is keyword kind, we want to display snippet result over keyword result for the exact match
              if a.kind == 14 or b.kind == 14 then
                local a_priority = snippets_win[a.source_id]
                local b_priority = snippets_win[b.source_id]
                if a_priority ~= b_priority then
                  return a_priority > b_priority
                end
              end
            end
          end,
          -- defaults
          "score",
          "sort_text",
        },
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
          auto_show_delay_ms = 100,
          update_delay_ms = 100,
          window = {
            border = "single",
            winblend = 0,
          },
        },
      },
      signature = { window = { border = "single" } },
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
      opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
        default = function(ctx)
          local row, column = unpack(vim.api.nvim_win_get_cursor(0))
          local success, node = pcall(vim.treesitter.get_node, { ignore_injections = false, pos = { row - 1, math.max(0, column - 1) } })
          if success and node and vim.tbl_contains({ "comment", "comment_content", "line_comment", "block_comment" }, node:type()) then
            return { "lsp" }
          else
            return { "lsp", "path", "snippets" }
          end
        end,
        providers = {
          lsp = {
            transform_items = function(_, items)
              return vim.tbl_filter(function(item)
                return item.kind ~= require("blink.cmp.types").CompletionItemKind.Text
                  and item.kind ~= require("blink.cmp.types").CompletionItemKind.Snippet
              end, items)
            end,
          },
          snippets = {
            should_show_items = function(ctx)
              return ctx.trigger.initial_kind ~= "trigger_character" and not require("blink.cmp").snippet_active()
            end,
          },
        },
      })

      return opts
    end,
  },
}
