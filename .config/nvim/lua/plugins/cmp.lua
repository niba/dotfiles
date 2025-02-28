--- Get completion context, i.e., auto-import/target module location.
--- Depending on the LSP this information is stored in different parts of the
--- lsp.CompletionItem payload. The process to find them is very manual: log the payloads
--- And see where useful information is stored.
---@param completion lsp.CompletionItem
---@param source cmp.Source
local function get_lsp_completion_context(completion, source)
  local ok, source_name = pcall(function()
    return source.source.client.config.name
  end)
  if not ok then
    return nil
  end

  if source_name == "rust_analyzer" or source_name == "rust-analyzer" then
    -- vim.cmd("redir >> debugcmp.log")
    -- vim.api.nvim_echo({ { "Debug message: " .. vim.inspect(completion) } }, true, {})
    -- vim.cmd("redir END")
    return completion.labelDetails.detail
  end
  if source_name == "tsserver" then
    return completion.detail
  elseif source_name == "pyright" or source_name == "vtsls" then
    if completion.labelDetails ~= nil then
      return completion.labelDetails.description
    end
  elseif source_name == "gopls" then
    return completion.detail
  end
end

local function get_lsp_completion_context2(completion)
  local ok, source_name = pcall(function()
    return vim.lsp.get_client_by_id(completion.client_id).name
  end)

  if not ok then
    return nil
  end

  if source_name == "rust_analyzer" or source_name == "rust-analyzer" then
    return completion.labelDetails.detail
  elseif source_name == "ts_ls" then
    return completion.detail
  elseif source_name == "pyright" or source_name == "vtsls" and completion.labelDetails ~= nil then
    return completion.labelDetails.description
  elseif source_name == "texlab" then
    return completion.detail
  elseif source_name == "clangd" then
    local doc = completion.documentation
    if doc == nil then
      return
    end

    local import_str = doc.value
    import_str = import_str:gsub("[\n]+", "")

    local str
    str = import_str:match("<(.-)>")
    if str then
      return "<" .. str .. ">"
    end

    str = import_str:match("[\"'](.-)[\"']")
    if str then
      return '"' .. str .. '"'
    end

    return nil
  end
end

local next_gen_cmp = true
local trigger_snippet_text = ";"

return {
  {
    "saghen/blink.cmp",
    opts = {
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      keymap = {
        preset = "enter",
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "accept", "snippet_forward", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
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
        menu = {
          border = "single",
          winblend = 0,
        },
        documentation = {
          window = {
            border = "single",
            winblend = 0,
          },
        },
      },
      snippets = {
        preset = "luasnip",
        -- This comes from the luasnip extra, if you don't add it, won't be able to
        -- jump forward or backward in luasnip snippets
        -- https://www.lazyvim.org/extras/coding/luasnip#blinkcmp-optional
        expand = function(snippet)
          require("luasnip").lsp_expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require("luasnip").jumpable(filter.direction)
          end
          return require("luasnip").in_snippet()
        end,
        jump = function(direction)
          require("luasnip").jump(direction)
        end,
      },
    },
  },
  {
    -- extend providers
    "saghen/blink.cmp",
    enabled = next_gen_cmp,
    opts = function(_, opts)
      opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
        default = { "lsp", "snippets", "path", "buffer", "codecompanion" },
        per_filetype = {
          codecompanion = { "lsp", "snippets", "buffer", "codecompanion" },
        },
        providers = {
          codecompanion = {
            name = "CodeCompanion",
            module = "codecompanion.providers.completion.blink",
            enabled = true,
          },
          snippets = {
            name = "snippets",
            enabled = true,
            max_items = 8,
            min_keyword_length = 2,
            module = "blink.cmp.sources.snippets",
            score_offset = 85, -- the higher the number, the higher the priority
            -- Only show snippets if I type the trigger_text characters, so
            -- to expand the "bash" snippet, if the trigger_text is ";" I have to
            should_show_items = function()
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
              -- NOTE: remember that `trigger_text` is modified at the top of the file
              return before_cursor:match(trigger_snippet_text .. "%w*$") ~= nil
            end,
            -- After accepting the completion, delete the trigger_text characters
            -- from the final inserted text
            transform_items = function(_, items)
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
              local trigger_pos = before_cursor:find(trigger_snippet_text .. "[^" .. trigger_snippet_text .. "]*$")
              if trigger_pos then
                for _, item in ipairs(items) do
                  item.textEdit = {
                    newText = item.insertText or item.label,
                    range = {
                      start = { line = vim.fn.line(".") - 1, character = trigger_pos - 1 },
                      ["end"] = { line = vim.fn.line(".") - 1, character = col },
                    },
                  }
                end
              end
              -- NOTE: After the transformation, I have to reload the luasnip source
              -- Otherwise really crazy shit happens and I spent way too much time
              -- figurig this out
              vim.schedule(function()
                require("blink.cmp").reload("snippets")
              end)
              return items
            end,
          },
        },
      })
    end,
  },
  -- nvim-cmp configuration so to not preselect completion and require tab to select
  -- Use <tab> for completion and snippets (supertab)
  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  {
    "L3MON4D3/LuaSnip",
    enabled = true,
    keys = function()
      return {}
    end,
  },
  {
    -- https://github.com/hrsh7th/nvim-cmp/issues/1038
    "hrsh7th/nvim-cmp",
    lazy = "VeryLazy",
    enabled = not next_gen_cmp,
    dependencies = {
      "hrsh7th/cmp-emoji",
      "L3MON4D3/LuaSnip",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local luasnip = require("luasnip")
      local cmp = require("cmp")
      -- local copilot = require("copilot.suggestion")

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local lazyDefaultFormat = opts.formatting.format

      opts.formatting.format = function(entry, vim_item)
        local item = lazyDefaultFormat(entry, vim_item)
        item.menu = ""
        local completion_context = get_lsp_completion_context(entry.completion_item, entry.source)
        if completion_context ~= nil and completion_context ~= "" then
          local truncated_context = string.sub(completion_context, 1, 70)
          local ellipsisIcon = "… "
          if truncated_context ~= completion_context then
            truncated_context = truncated_context .. ellipsisIcon
          end
          item.menu = item.menu .. " " .. truncated_context
        end

        item.menu_hl_group = "CmpItemAbbr"
        return item
      end

      opts.experimental = {
        ghost_text = false,
      }

      opts.view = {
        entries = {
          name = "custom",
          selection_order = "top_down",
          follow_cursor = true,
        },
        docs = {
          auto_open = true,
        },
      }

      opts.window = {
        documentation = cmp.config.window.bordered(),
      }

      -- vim.api.nvim_echo({ { "config" .. vim.inspect(opts) } }, true, {})
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          -- if copilot ~= nil and copilot.is_visible() then
          --   copilot.accept()
          if cmp.visible() then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),

        -- ["<C-.>"] = cmp.mapping(function()
        --   if copilot.is_visible() then
        --     copilot.next()
        --   end
        -- end),
        -- ["<C-,>"] = cmp.mapping(function()
        --   if copilot.is_visible() then
        --     copilot.prev()
        --   end
        -- end),
      })

      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "emoji" } }))
    end,
  },
}
