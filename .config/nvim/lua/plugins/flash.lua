-- https://github.com/folke/flash.nvim/issues/204
return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      -- qwerty
      -- labels = "asdfghjklqwertyuiopzxcvbnm",
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
      -- jump = {
      --   autojump = true,
      -- },
    },
  },
}
