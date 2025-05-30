return {
  {
    "folke/todo-comments.nvim",
    opts = function(_, opts)
      local default_keywords = {
        FIX = {
          icon = " ", -- icon used for the sign, and in search results
          color = "error", -- can be a hex color, or a named color (see below)
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      }
      local custom_keywords = {
        WORK = {
          icon = " ",
          color = "#ff9c8f",
        },
      }

      opts.keywords = vim.tbl_deep_extend("force", {}, default_keywords, custom_keywords)

      -- add support for lowercase
      for key, val in pairs(opts.keywords) do
        opts.keywords[key:lower()] = val
      end
    end,
    keys = {
      {
        "]l",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next Todo Comment",
      },
      {
        "[l",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous Todo Comment",
      },
      {
        "]z",
        function()
          require("todo-comments").jump_next({ keywords = { "WORK" } })
        end,
        desc = "Next work comment",
      },
      {
        "[z",
        function()
          require("todo-comments").jump_prev({ keywords = { "WORK" } })
        end,
        desc = "Previous work comment",
      },
      { "<leader>xz", "<cmd>TodoTrouble keywords=WORK,work<cr>", desc = "Todo (Trouble)" },
      { "<leader>sz", "<cmd>TodoTelescope keywords=WORK,work<cr>", desc = "Work Todo" },
      {
        "<leader>xT",
        "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME,todo,fix,fixme}}<cr>",
        desc = "Todo/Fix/Fixme (Trouble)",
      },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME,todo,fix,fixme<cr>", desc = "Todo/Fix/Fixme" },
    },
  },
}
