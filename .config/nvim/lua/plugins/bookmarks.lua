return {
  {
    "LintaoAmons/bookmarks.nvim",
    tag = "v0.5.3", -- optional, pin the plugin at specific version for stability
    event = "VeryLazy",
    enabled = false,
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
    },
    keys = {

      { "<leader>m", "<cmd>BookmarksMark<cr>", desc = "Mark file" },
      { "<leader>fm", "<cmd>BookmarksGoto<cr>", desc = "Marked file" },
      { "<leader>fMc", "<cmd>BookmarksCommands<cr>", desc = "Bookmark commands" },
      { "<leader>fMr", "<cmd>BookmarksGotoRecent<cr>", desc = "Open recent marked file" },
      { "<leader><tab>", "<cmd>BookmarksGotoRecent<cr>", desc = "Open recent marked file" },
    },
  },
  {
    "cbochs/grapple.nvim",
    enabled = true,
    opts = {
      scope = "git_branch", -- also try out "git_branch"
      win_opts = {
        width = 720,
      },
    },
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = "Grapple",
    setup = function()
      require("telescope").load_extension("grapple")
    end,
    keys = {
      { "<leader>m", "<cmd>Grapple toggle<cr>", desc = "Mark file" },

      {
        "<leader>fm",
        function()
          local telescope = require("telescope")
          telescope.extensions.grapple.tags({
            layout_strategy = "vertical",
            path_display = { "filename_first" },
          })
        end,
        -- '<cmd>Telescope grapple tags layout_strategy=vertical path_display=vim.fn.json_encode({"filename_first"}) <cr>',
        desc = "Open marked files",
      },
      {
        "<tab>a",
        function()
          local telescope = require("telescope")
          telescope.extensions.grapple.tags({
            layout_strategy = "vertical",
            path_display = { "filename_first" },
          })
        end,
        -- '<cmd>Telescope grapple tags layout_strategy=vertical path_display=vim.fn.json_encode({"filename_first"}) <cr>',
        desc = "Open marked files",
      },
      {
        "<leader><tab>",
        function()
          local telescope = require("telescope")
          telescope.extensions.grapple.tags({
            layout_strategy = "vertical",
            path_display = { "filename_first" },
          })
        end,
        -- '<cmd>Telescope grapple tags layout_strategy=vertical path_display=vim.fn.json_encode({"filename_first"}) <cr>',
        desc = "Open marked files",
      },
      -- { "<leader><tab>", "<leader>fm", desc = "Open marked files", remap = true },

      { "<leader>fMa", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple toggle tags" },
      -- { "<leader>K", "<cmd>Grapple toggle_scopes<cr>", desc = "Grapple toggle scopes" },
      { "<leader>fMn", "<cmd>Grapple cycle forward<cr>", desc = "Grapple cycle forward" },
      { "<leader>fMp", "<cmd>Grapple cycle backward<cr>", desc = "Grapple cycle backward" },

      { "<leader>4", "<cmd>Grapple select index=1<cr>", desc = "which_key_ignore" },
      { "<leader>5", "<cmd>Grapple select index=2<cr>", desc = "which_key_ignore" },
      { "<leader>6", "<cmd>Grapple select index=3<cr>", desc = "which_key_ignore" },
      { "<leader>0", "<cmd>Grapple select index=4<cr>", desc = "which_key_ignore" },
      { "<leader>7", "<cmd>Grapple select index=5<cr>", desc = "which_key_ignore" },
      { "<leader>8", "<cmd>Grapple select index=6<cr>", desc = "which_key_ignore" },
      { "<leader>9", "<cmd>Grapple select index=7<cr>", desc = "which_key_ignore" },
    },
  },
  {
    "will-lynas/grapple-line.nvim",
    enabled = false,
    dependencies = {
      "cbochs/grapple.nvim",
    },
    opts = {
      show_names = true,
      number_of_files = 5,
    },
  },
}
