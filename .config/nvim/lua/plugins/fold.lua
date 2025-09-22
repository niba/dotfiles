return {
  {
    -- sets folding to manual and breaks lsp / treesitter folds
    "dmtrKovalenko/fold-imports.nvim",
    enabled = false,
    opts = {
      custom_fold_text = false,
      fold_level = 99,
    },
    event = "BufRead",
  },
  {
    "chrisgrieser/nvim-origami",
    enabled = true,
    opts = {
      foldtext = {
        padding = 2,
        lineCount = { template = "󰘖 %d" },
      },
    },
    keys = {
      {
        "<Left>",
        function()
          require("origami").h()
        end,
      },
      {
        "<Right>",
        function()
          require("origami").l()
        end,
      },
    },
    event = "VeryLazy",
  },
}
