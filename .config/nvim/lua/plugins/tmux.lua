return {
  {
    "christoomey/vim-tmux-navigator",
    enabled = true,
    event = "BufReadPre",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<C-n>", "<cmd>TmuxNavigateLeft<cr>", mode = { "n", "v" }, desc = "which_key_ignore" },
      { "<C-e>", "<cmd>TmuxNavigateDown<cr>", mode = { "n", "v" }, desc = "which_key_ignore" },
      { "<F8>", "<cmd>TmuxNavigateUp<cr>", mode = { "n", "v" }, desc = "which_key_ignore" },
      { "<C-o>", "<cmd>TmuxNavigateRight<cr>", mode = { "n", "v" }, desc = "which_key_ignore" },
      { "<C-Left>", "<cmd>TmuxNavigateLeft<cr>", mode = { "n", "v" }, desc = "which_key_ignore" },
      { "<C-Down>", "<cmd>TmuxNavigateDown<cr>", mode = { "n", "v" }, desc = "which_key_ignore" },
      { "<C-Up>", "<cmd>TmuxNavigateUp<cr>", mode = { "n", "v" }, desc = "which_key_ignore" },
      { "<C-Right>", "<cmd>TmuxNavigateRight<cr>", mode = { "n", "v" }, desc = "which_key_ignore" },
      -- we probably need to create our own custom command
      -- { "<C-p>", "<cmd>TmuxNavigatePrevious<cr>", mode = { "n", "v" }, desc = "which_key_ignore" },
    },

    init = function()
      vim.g.tmux_navigator_no_wrap = 1
    end,
  },
}
