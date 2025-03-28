-- How to handle circular text objects better like assignment?
--
return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    opts = {
      max_lines = 2,
    },
  },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    enabled = true,
    config = function(_, opts)
      local configuration = {
        { " ", desc = "whitespace" },
        { '"', desc = '" string' },
        { "'", desc = "' string" },
        { "(", desc = "() block" },
        { ")", desc = "() block with ws" },
        { "<", desc = "<> block" },
        { ">", desc = "<> block with ws" },
        { "?", desc = "user prompt" },
        { "[", desc = "[] block" },
        { "]", desc = "[] block with ws" },
        { "{", desc = "{} block" },
        { "}", desc = "{} with ws" },
        { "_", desc = "underscore" },
        { "`", desc = "` string" },
        { "CR", desc = "paragraph" },

        { "a", desc = "argument" },
        { "b", desc = ")]} block" },
        { "c", desc = "class" },
        { "e", desc = "use/call" },
        { "E", desc = "use/call without dot" },
        { "f", desc = "function" },
        { "g", desc = "entire file" },
        { "i", desc = "indent" },
        { "j", desc = "jsx tag" },
        { "m", desc = "markdown code" },
        { "o", desc = "block, conditional, loop" },
        { "p", desc = "assignment" },
        { "s", desc = "quote `\"'" },
        { "t", desc = "type" },
        { "u", desc = "CamelCase / snake_case" },
      }

      require("mini.ai").setup(opts)
      LazyVim.on_load("which-key.nvim", function()
        vim.schedule(function()
          require("extras.which_key").register_miniai(opts, configuration)
        end)
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

      opts.custom_textobjects = vim.tbl_deep_extend("force", opts.custom_textobjects or {}, {
        s = { { "%b''", '%b""', "%b``" }, "^.().*().$" },
        p = ai.gen_spec.treesitter({ a = "@assignment.lhs", i = "@assignment.rhs" }, {}),
        j = ai.gen_spec.treesitter({ a = "@jsx_element.outer", i = "@jsx_element.inner" }, {}),
        t = ai.gen_spec.treesitter({ a = "@type.outer", i = "@type.inner" }, {}),
        u = {
          {
            "%u[%l%d]+%f[^%l%d]",
            "%f[%S][%l%d]+%f[^%l%d]",
            "%f[%P][%l%d]+%f[^%l%d]",
            "^[%l%d]+%f[^%l%d]",
          },
          "^().*()$",
        },
        E = ai.gen_spec.function_call(),
        e = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
      })

      return opts
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      textobjects = {
        move = {
          enable = true,
          set_jumps = true,
          goto_previous_start = {
            ["[j"] = "@jsx_element.outer",
            ["[m"] = "@code_block.inner",
            ["[p"] = "@assignment.rhs",
            ["[t"] = "@type.inner",
          },
          goto_next_start = {
            ["]j"] = "@jsx_element.outer",
            ["]m"] = "@code_block.inner",
            ["]p"] = "@assignment.rhs",
            ["]t"] = "@type.inner",
          },
        },
      },
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
