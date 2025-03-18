-- we want to use sort that works like zf, not fzf
local function zf_sorter(picker, fields)
  local normalized_fields = {} ---@type snacks.picker.sort.Field[]
  for _, f in ipairs(fields or { { name = "score", desc = true }, "idx" }) do
    if type(f) == "string" then
      local desc, len = false, nil
      if f:sub(1, 1) == "#" then
        f, len = f:sub(2), true
      end
      if f:sub(-5) == ":desc" then
        f, desc = f:sub(1, -6), true
      elseif f:sub(-4) == ":asc" then
        f = f:sub(1, -5)
      end
      table.insert(normalized_fields, { name = f, desc = desc, len = len })
    else
      table.insert(normalized_fields, f)
    end
  end

  -- print(picker.source .. " " .. vim.inspect(normalized_fields))
  -- example of fields = { "score:desc", "#text", "idx" }

  if picker.source == "recent" or picker.source == "buffers" then
    local function abs(n)
      return n < 0 and -n or n
    end
    local TOO_FAR = 5
    return function(a, b)
      local av, bv = a.score, b.score

      if av ~= bv then
        return av > bv
      end

      av, bv = a.idx, b.idx

      if abs(av - bv) < TOO_FAR then
        return av < bv
      end

      av, bv = a.text, b.text

      -- av, bv = a.file and #(vim.fn.fnamemodify(av, ":t")) or #av, b.file and #(vim.fn.fnamemodify(bv, ":t")) or #bv
      av, bv = a.filename and #a.filename or #av, b.filename and #b.filename or bv

      if av ~= bv then
        return av < bv
      end

      return a.idx < b.idx
    end
  end

  return function(a, b)
    for _, field in ipairs(normalized_fields) do
      local av, bv = a[field.name], b[field.name]
      if av ~= nil and bv ~= nil then
        if field.len then
          av, bv = #av, #bv
        end
        if av ~= bv then
          if field.desc then
            return av > bv
          else
            return av < bv
          end
        end
      end
    end
    return false
  end
end

local flash_on_picker = function(picker)
  require("flash").jump({
    pattern = "^",
    label = { after = { 0, 0 } },
    search = {
      mode = "search",
      exclude = {
        function(win)
          return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
        end,
      },
    },
    action = function(match)
      local idx = picker.list:row2idx(match.pos[1])
      picker.list:_move(idx, true, true)
      -- you can also add auto confirm here
    end,
  })
end

local function fuzzy_oil()
  local find_command = {
    "fd",
    "--type",
    "d",
    "--color",
    "never",
  }

  vim.fn.jobstart(find_command, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        local filtered = vim.tbl_filter(function(el)
          return el ~= ""
        end, data)

        local items = {}
        for _, v in ipairs(filtered) do
          table.insert(items, { text = v })
        end

        ---@module 'snacks'
        Snacks.picker.pick({
          source = "directories",
          items = items,
          layout = { preset = "select" },
          format = "text",
          confirm = function(picker, item)
            picker:close()
            require("oil").open(item.text)
            -- vim.cmd("Oil " .. item.text)
          end,
        })
      end
    end,
  })
end

local quick_layout = {
  preview = false,
  layout = {
    backdrop = false,
    row = 1,
    width = 0.4,
    min_width = 80,
    height = 0.4,
    border = "none",
    box = "vertical",
    { win = "input", height = 1, border = "rounded", title = "{title} {live} {flags}", title_pos = "center" },
    { win = "list", border = "hpad" },
    { win = "preview", title = "{preview}", border = "rounded" },
  },
}

local custom_vscode = {
  preview = false,
  layout = {
    backdrop = false,
    row = 1,
    width = 0.4,
    min_width = 80,
    height = 0.4,
    border = "rounded",
    box = "vertical",
    {
      win = "input",
      height = 1,
      border = "bottom",
      title = "{title} {live} {flags}",
      title_pos = "center",
    },
    { win = "list", border = "hpad" },
    { win = "preview", title = "{preview}", border = "rounded" },
  },
}

local treesitter_filter = function(match)
  -- local next_sib = match.node:next_named_sibling()
  -- local next_sib_type = next_sib and next_sib:type() or nil
  -- var .. | .. local.definition.var  = identifier  sib  arrow_function
  local pairs = {
    { "import_statement" },
    { "function_declaration" },
    { "identifier", "arrow_function" },
    { "identifier", "function_expression" },
  }

  for _, pair in ipairs(pairs) do
    if pair[1] == match.node:type() then
      if pair[2] == nil then
        return true
      end

      local next_sib = match.node:next_named_sibling()
      if next_sib == nil then
        return false
      end
      print(next_sib:type())

      return next_sib:type() == pair[2]
    end
  end

  -- if match.node:type() == "identifier" and next_sib_type == "arrow_function" then
  --   return true
  -- end
  return false
  -- print(match.kind .. " .. | .. " .. match.name .. "  = " .. match.node:type() .. "  sib  " .. b)
end

return {
  {
    "stevearc/aerial.nvim",
    opts = {
      filter_kind = false,
      backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },
      autojump = true,
      highlight_on_hover = true,
      nav = {
        autojump = true,
      },
      -- backends = { "treesi" },
    },
    keys = {
      {
        "<leader>cx",
        function()
          require("aerial").snacks_picker({
            layout = { preset = "sidebar", preview = "main", layout = { position = "right" } },
          })
          -- Snacks.picker.lsp_symbols({ layout = "right" })
        end,
        desc = "LSP Symbols",
      },
    },
  },
  -- {
  --   "bassamsdata/namu.nvim",
  --   config = function()
  --     require("namu").setup({
  --       -- Enable the modules you want
  --       namu_symbols = {
  --         enable = true,
  --         options = {}, -- here you can configure namu
  --       },
  --       -- Optional: Enable other modules if needed
  --       ui_select = { enable = false }, -- vim.ui.select() wrapper
  --       colorscheme = {
  --         enable = false,
  --         options = {
  --           -- NOTE: if you activate persist, then please remove any vim.cmd("colorscheme ...") in your config, no needed anymore
  --           persist = true, -- very efficient mechanism to Remember selected colorscheme
  --           write_shada = false, -- If you open multiple nvim instances, then probably you need to enable this
  --         },
  --       },
  --     })
  --     -- === Suggested Keymaps: ===
  --     vim.keymap.set("n", "<leader>cg", ":Namu symbols<cr>", {
  --       desc = "Jump to LSP symbol",
  --       silent = true,
  --     })
  --     vim.keymap.set("n", "<leader>cG", ":Namu colorscheme<cr>", {
  --       desc = "Colorscheme Picker",
  --       silent = true,
  --     })
  --   end,
  -- },
  -- {
  --   "oskarrrrrrr/symbols.nvim",
  --   config = function()
  --     local r = require("symbols.recipes")
  --     require("symbols").setup(r.DefaultFilters, r.AsciiSymbols, {
  --       -- custom settings here
  --       -- e.g. hide_cursor = false
  --     })
  --     vim.keymap.set("n", "<leader>cg", "<cmd> Symbols<CR>")
  --     vim.keymap.set("n", "<leader>cG", "<cmd> SymbolsClose<CR>")
  --   end,
  -- },

  {
    "workbuffers.nvim",
    -- enabled = testing,
    dev = true,
    lazy = false,
    config = true,
    keys = {
      {
        "<leader>,",
        function()
          require("workbuffers").list({
            current = false,
            layout = custom_vscode,
          })
        end,
        desc = "Buffers",
      },
    },
  },
  {
    "folke/snacks.nvim",
    dev = true,
    opts = {
      debug = {

        explorer = true, -- show explorer debug info
      },
      scroll = { enabled = false },
      picker = {
        auto_close = false,
        actions = {
          flash = flash_on_picker,
        },
        -- custom modification
        sorter = zf_sorter,
        grep = {
          regex = false,
        },
        formatters = {
          file = {
            filename_first = true, -- display filename before the file path
            truncate = 100,
          },
        },
        win = {
          input = {
            keys = {
              ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
            },
          },
        },
      },
    },
    keys = {
      {
        "<leader><space>",
        function()
          Snacks.picker.smart()
        end,
        desc = "Smart find",
      },
      {
        "<leader>fo",
        function()
          fuzzy_oil()
        end,
        desc = "Smart find",
      },
      -- {
      --   "<leader>,",
      --   function()
      --     Snacks.picker.buffers({
      --       current = false,
      --       layout = custom_vscode,
      --     })
      --   end,
      --   desc = "Buffers - auto flash",
      -- },
      {
        "<leader>r",
        function()
          Snacks.picker.resume()
        end,
        desc = "Resume picker",
      },
      {
        "<leader>su",
        function()
          Snacks.picker.undo()
        end,
        desc = "Open undo history",
      },
      {
        "<leader>sx",
        function()
          Snacks.picker.treesitter({
            filter = {
              typescript = treesitter_filter,
            },
          })
          -- Snacks.picker.lsp_symbols({
          --   -- layout = "main",
          --   tree = false,
          --   filter = {
          --     default = {
          --       "Class",
          --       "Constructor",
          --       "Enum",
          --       "Field",
          --       "Function",
          --       "Interface",
          --       "Method",
          --       "Module",
          --       "Namespace",
          --       "Package",
          --       -- "Property",
          --       "Struct",
          --       "Trait",
          --       "Variable",
          --     },
          --   },
          -- })
        end,
        desc = "Open undo history",
      },
      {
        "<leader>sP",
        function()
          Snacks.picker.files({ rtp = true, pattern = "file:md$ " })
        end,
        desc = "Lazy plugins",
      },
    },
  },
}
