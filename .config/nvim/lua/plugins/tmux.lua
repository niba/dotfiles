return {
  {
    "mrjones2014/smart-splits.nvim",
    enabled = false,
    keys = {
      {
        "<C-n>",
        function()
          require("smart-splits").resize_left()
        end,
        mode = { "n", "v" },
        desc = "which_key_ignore",
      },
      {
        "<C-e>",
        function()
          require("smart-splits").move_cursor_down()
        end,
        mode = { "n", "v" },
        desc = "which_key_ignore",
      },
      {
        "<F8>",
        function()
          require("smart-splits").move_cursor_up()
        end,
        mode = { "n", "v" },
        desc = "which_key_ignore",
      },
      {
        "<C-o>",
        function()
          require("smart-splits").move_cursor_right()
        end,
        mode = { "n", "v" },
        desc = "which_key_ignore",
      },
      {
        "<C-Left>",
        function()
          require("smart-splits").move_cursor_left()
        end,
        mode = { "n", "v" },
        desc = "which_key_ignore",
      },
      {
        "<C-Down>",
        function()
          require("smart-splits").move_cursor_down()
        end,
        mode = { "n", "v" },
        desc = "which_key_ignore",
      },
      {
        "<C-Up>",
        function()
          require("smart-splits").move_cursor_up()
        end,
        mode = { "n", "v" },
        desc = "which_key_ignore",
      },
      {
        "<C-Right>",
        function()
          require("smart-splits").move_cursor_right()
        end,
        mode = { "n", "v" },
        desc = "which_key_ignore",
      },
      {
        "<leader>ml",
        function()
          require("smart-splits").swap_buf_right()
        end,
        mode = { "n", "v" },
        desc = "swap right",
      },
      {
        "<leader>mh",
        function()
          require("smart-splits").swap_buf_left()
        end,
        mode = { "n", "v" },
        desc = "swap left",
      },
    },
  },
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
