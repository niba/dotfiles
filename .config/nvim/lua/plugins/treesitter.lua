-- Many keybindings are rewritten from the lazy defaults
return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    opts = {
      max_lines = 2,
    },
  },
  {
    "echasnovski/mini.indentscope",
    opts = {
      mappings = {
        -- Textobjects
        object_scope = "iu",
        object_scope_with_border = "au",

        -- Motions (jump to respective border line; if not present - body line)
        goto_top = "[u",
        goto_bottom = "]u",
      },
    },
  },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    enabled = true,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      -- register all text objects with which-key
      -- code taken from lazy
      require("lazyvim.util").on_load("which-key.nvim", function()
        ---@type table<string, string|table>
        local objects = {
          [" "] = "Whitespace",
          ['"'] = 'Balanced "',
          ["'"] = "Balanced '",
          ["`"] = "Balanced `",
          ["("] = "Balanced (",
          [")"] = "Balanced ) including white-space",
          [">"] = "Balanced > including white-space",
          ["<lt>"] = "Balanced <",
          ["]"] = "Balanced ] including white-space",
          ["["] = "Balanced [",
          ["}"] = "Balanced } including white-space",
          ["{"] = "Balanced {",
          ["?"] = "User Prompt",
          _ = "Underscore",
          a = "Argument",
          p = "Parameter (jsx attribute)",
          b = "Balanced ), ], }",
          c = "Class",
          d = "Digit(s)",
          m = "Word in CamelCase & snake_case",
          f = "Function",
          g = "Entire file",
          i = "Assignment",
          o = "Block, conditional, loop",
          q = "Quote `, \", '",
          s = "Quote `, \", '",
          t = "Tag",
          E = "Use/call function & method",
          e = "Use/call without dot in name",
          u = "Indent scope",
          ["Enter"] = "Paragraph",
        }
        local ret = { mode = { "o", "x" } }
        for prefix, name in pairs({
          i = "inside",
          a = "around",
          il = "last",
          ["in"] = "next",
          al = "last",
          an = "next",
        }) do
          ret[#ret + 1] = { prefix, group = name }
          for _, obj in ipairs(objects) do
            ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
          end
        end
        require("which-key").add(ret, { notify = false })

        -- local a = vim.deepcopy(i)
        -- for k, v in pairs(a) do
        --   a[k] = v:gsub(" including.*", "")
        -- end
        --
        -- local ic = vim.deepcopy(i)
        -- local ac = vim.deepcopy(a)
        -- for key, name in pairs({ n = "Next", l = "Last" }) do
        --   i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
        --   a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
        -- end
        -- require("which-key").register({
        --   mode = { "o", "x" },
        --   i = i,
        --   a = a,
        -- })
      end)
    end,
    opts = function(_, opts)
      local ai = require("mini.ai")

      -- Remap a<Enter> to ap (a paragraph)
      vim.api.nvim_set_keymap("x", "a<CR>", "ap", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("o", "a<CR>", "ap", { noremap = true, silent = true })

      -- Remap i<Enter> to ip (inner paragraph)
      vim.api.nvim_set_keymap("x", "i<CR>", "ip", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("o", "i<CR>", "ip", { noremap = true, silent = true })

      -- Remap built-in tag text objects
      vim.keymap.set({ "o", "x" }, "ir", "it", { noremap = true })
      vim.keymap.set({ "o", "x" }, "ar", "at", { noremap = true })

      -- sometimes better but we can get into circular navigation
      -- opts.search_method = "cover_or_nearest"

      opts.custom_textobjects = {
        o = ai.gen_spec.treesitter({
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }, {}),
        s = { { "%b''", '%b""', "%b``" }, "^.().*().$" },
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        p = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }, {}),
        i = ai.gen_spec.treesitter({ a = "@assignment.lhs", i = "@assignment.rhs" }, {}),
        t = ai.gen_spec.treesitter({ a = "@type.outer", i = "@type.inner" }, {}),
        -- bult in tag textobject is better
        -- t = false,
        d = { "%f[%d]%d+" }, -- digits
        m = { -- Word with case
          {
            "%u[%l%d]+%f[^%l%d]",
            "%f[%S][%l%d]+%f[^%l%d]",
            "%f[%P][%l%d]+%f[^%l%d]",
            "^[%l%d]+%f[^%l%d]",
          },
          "^().*()$",
        },
        g = function() -- Whole buffer, similar to `gg` and 'G' motion
          local from = { line = 1, col = 1 }
          local to = {
            line = vim.fn.line("$"),
            col = math.max(vim.fn.getline("$"):len(), 1),
          }
          return { from = from, to = to }
        end,
        E = ai.gen_spec.function_call(), -- u for "Usage"
        e = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
      }

      return opts
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-CR>",
          node_incremental = "<C-CR>",
          scope_incremental = false,
          node_decremental = "<C-bs>",
        },
      },
    },
  },
  {
    "ColinKennedy/cursor-text-objects.nvim",
    config = function()
      vim.keymap.set(
        { "o", "x" },
        "[",
        "<Plug>(cursor-text-objects-up)",
        { desc = "Run from your current cursor to the end of the text-object." }
      )
      vim.keymap.set(
        { "o", "x" },
        "]",
        "<Plug>(cursor-text-objects-down)",
        { desc = "Run from your current cursor to the end of the text-object." }
      )
    end,
    version = "v1.*",
  },
}
