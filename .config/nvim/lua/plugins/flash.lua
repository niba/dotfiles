-- https://github.com/folke/flash.nvim/issues/204
return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      -- colemak
      labels = "arstgmneioqwfpbjluyzxcdvkh",
      label = {
        uppercase = false,
      },
      modes = {
        search = {
          enabled = false,
        },
        char = {
          multi_line = false,
          jump_labels = true,
          jump = {
            autojump = true,
          },
        },
        treesitter = {
          labels = "arstgmneioqwfpbjluyzxcdvkh",
        },
      },
    },
    keys = function()
      return {
        {
          "s",
          mode = { "n", "x", "o" },
          function()
            require("flash").jump()
          end,
          desc = "Flash",
        },
        {
          "S",
          mode = { "n", "o", "x" },
          function()
            require("flash").treesitter()
          end,
          desc = "Flash Treesitter",
        },
        {
          "o",
          mode = "o",
          function()
            require("flash").remote()
          end,
          desc = "Remote Flash",
        },
        {
          "O",
          mode = { "o", "x" },
          function()
            require("flash").treesitter_search()
          end,
          desc = "Treesitter Search",
        },
      }
    end,
  },
}
