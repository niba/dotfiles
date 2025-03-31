return {
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
    dependencies = {
      "nvim-telescope/telescope.nvim",
      -- "ibhagwan/fzf-lua",
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      lang = "typescript",
      description = {
        position = "right",
      },
      keys = {
        toggle = { "q" }, ---@type string|string[]
        confirm = { "<CR>" }, ---@type string|string[]

        reset_testcases = "<localleader>x", ---@type string
        use_testcase = "<localleader>u", ---@type string
        focus_testcases = "<localleader>t", ---@type string
        focus_result = "<localleader>r", ---@type string
      },
    },
  },
}
