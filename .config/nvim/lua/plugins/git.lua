return {
  {
    "akinsho/git-conflict.nvim",
    event = "VimEnter",
    opts = {
      default_mappings = false,
    },
    keys = {
      { "<leader>co", "<Plug>(git-conflict-ours)", desc = "Git Conflict Ours" },
      { "<leader>ct", "<Plug>(git-conflict-theirs)", desc = "Git Conflict Theirs" },
      { "<leader>cb", "<Plug>(git-conflict-both)", desc = "Git Conflict Both" },
      { "<leader>cn", "<Plug>(git-conflict-none)", desc = "Git Conflict none" },
    },
  },
  {
    -- we use gitsigns only for blame
    "lewis6991/gitsigns.nvim",
    enabled = true,
    opts = {
      current_line_blame_opts = {
        delay = 0,
      },
      signs_staged_enable = false,
      signcolumn = false,
      on_attach = function(buffer) end,
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = function()
      vim.schedule(function()
        Snacks.toggle({
          name = "Git blame line",
          get = function()
            return require("gitsigns.config").config.current_line_blame
          end,
          set = function(state)
            require("gitsigns").toggle_current_line_blame(state)
          end,
        }):map("<leader>gb")
      end)
    end,
  },
  {
    "pwntester/octo.nvim",
    opts = {
      use_local_fs = true,
      reviews = {
        auto_show_threads = false,
      },
    },
  },
  { "tpope/vim-fugitive", cmd = { "Git", "G" } },
}
