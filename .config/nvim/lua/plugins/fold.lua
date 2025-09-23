return {
  {
    -- sets folding to manual and breaks lsp / treesitter folds
    "dmtrKovalenko/fold-imports.nvim",
    enabled = true,
    opts = {
      custom_fold_text = false,
      fold_level = 99,
    },
    event = "BufRead",
  },
  {
    "chrisgrieser/nvim-origami",
    enabled = true,
    init = function()
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
    end,
    config = function(_, opts)
      require("origami").setup(opts)
      vim.api.nvim_clear_autocmds({ group = "origami.foldexpr" })
    end,
    opts = {
      foldtext = {
        padding = 2,
        lineCount = { template = "󰘖 %d" },
      },
      autoFold = {
        enabled = false,
        kinds = { "imports" },
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
