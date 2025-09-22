-- How to handle circular text objects better like assignment?
--
return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    opts = {
      max_lines = 3,
      multiline_threshold = 1,
      trim_scope = "inner",
    },
    keys = {
      {
        "gC",
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end,
        desc = "Goto treesitter context",
      },
    },
  },
  {
    "aaronik/treewalker.nvim",
    event = "VeryLazy",
    opts = {
      highlight = true,
      highlight_duration = 250,
      highlight_group = "CursorLine",
    },
    keys = {
      {
        "<M-up>",
        function()
          require("treewalker").move_up()
        end,
        mode = { "n", "v" },
      },
      {
        "<M-down>",
        function()
          require("treewalker").move_down()
        end,
        mode = { "n", "v" },
      },
      {
        "<M-left>",
        function()
          require("treewalker").move_out()
        end,
        mode = { "n", "v" },
      },
      {
        "<M-right>",
        function()
          require("treewalker").move_in()
        end,
        mode = { "n", "v" },
      },

      {
        "<M-S-up>",
        function()
          require("treewalker").swap_up()
        end,
      },
      {
        "<M-S-down>",
        function()
          require("treewalker").swap_down()
        end,
      },
      {
        "<M-S-left>",
        function()
          require("treewalker").swap_left()
        end,
      },
      {
        "<M-S-right>",
        function()
          require("treewalker").swap_right()
        end,
      },
    },
  },
  {
    "nvim-mini/mini.ai",
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
        p = ai.gen_spec.treesitter({ a = "@assignment.lhs", i = "@assignment.rhs" }, { use_nvim_treesitter = true }),
        j = ai.gen_spec.treesitter({ a = "@jsx_element.outer", i = "@jsx_element.inner" }, { use_nvim_treesitter = true }),
        t = ai.gen_spec.treesitter(
          { a = { "@type.outer", "@attribute.outer" }, i = { "@type.inner", "@attribute.inner" } },
          { use_nvim_treesitter = true }
        ),
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

        -- remove after fixing use_nvim_treesitter default value
        o = ai.gen_spec.treesitter({ -- code block
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }, { use_nvim_treesitter = true }),
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, { use_nvim_treesitter = true }), -- function
        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, { use_nvim_treesitter = true }), -- class
      })

      return opts
    end,
  },
  {
    "acarapetis/nvim-treesitter-jjconfig",
    enabled = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    lazy = false,
    opts = { ensure_installed = true },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    opts = {
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
  },
  {
    "ColinKennedy/cursor-text-objects.nvim",
    config = function()
      vim.keymap.set({ "o", "x" }, "[", "<Plug>(cursor-text-objects-up)", { desc = "Run from your current cursor to the end of the text-object." })
      vim.keymap.set({ "o", "x" }, "]", "<Plug>(cursor-text-objects-down)", { desc = "Run from your current cursor to the end of the text-object." })
    end,
    version = "v1.*",
  },
}
