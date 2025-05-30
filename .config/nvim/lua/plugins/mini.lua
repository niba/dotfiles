return {
  {
    "echasnovski/mini.move",
    event = "VeryLazy",
    opts = {
      mappings = {
        left = "<C-S-left>",
        right = "<C-S-right>",
        down = "<C-S-down>",
        up = "<C-S-up>",

        line_left = "<C-S-left>",
        line_right = "<C-S-right>",
        line_down = "<C-S-down>",
        line_up = "<C-S-up>",
      },
    },
  },
  { "echasnovski/mini.pairs", enabled = false },
  -- dont remove lazy = false
  { "echasnovski/mini.test", version = false },
}
