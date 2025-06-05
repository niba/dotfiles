local function testing()
  local cwd = vim.fn.getcwd()

  return string.find(cwd, "Projects/plugin_testing", 1, true) ~= nil
end

return {
  {
    "continue",
    -- enabled = testing,
    enabled = true,
    dev = true,
    lazy = false,
    config = true,
    keys = {
      {
        "<leader>ml",
        function()
          require("continue").search()
        end,
        desc = "List sessions",
      },
      {
        "<leader>ms",
        function()
          require("continue").save()
        end,
        desc = "Save session",
      },
      {
        "<leader>mj",
        function()
          require("continue").jumplist()
        end,
        desc = "Save session",
      },
    },
    ---@module "continue"
    ---@type Continue.Config
    opts = {

      -- hooks = {
      --   post_restore = function()
      --     vim.cmd([[Neotree filesystem show]])
      --   end,
      -- },
      extensions = {
        "workbuffers.continue",
        "continue.sessions.extensions.quickfix",
        function()
          return require("continue.sessions.extensions.codecompanion")
        end,
      },
    },
  },
  {
    "folke/persistence.nvim",
    enabled = false,
  },
  {
    "rmagatti/auto-session",
    lazy = false,
    enabled = false,
    opts = {
      auto_save = true,
      auto_restore = true,
      lsp_stop_on_restore = true,
    },
  },
}
