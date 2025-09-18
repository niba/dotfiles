return {
  {
    "nvim-mini/mini.move",
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
  { "nvim-mini/mini.pairs", enabled = false },
  -- dont remove lazy = false
  { "nvim-mini/mini.test", version = false },
}
