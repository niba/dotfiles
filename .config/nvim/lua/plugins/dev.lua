local function testing()
  local cwd = vim.fn.getcwd()

  return string.find(cwd, "Projects/plugin_testing", 1, true) ~= nil
end

return {
  {
    "continuum",
    -- enabled = testing,
    enabled = true,
    dev = true,
    lazy = false,
    config = true,
    keys = {
      {
        "<leader>ml",
        function()
          require("continuum").search()
        end,
        desc = "List sessions",
      },
      {
        "<leader>ms",
        function()
          require("continuum").save()
        end,
        desc = "Save session",
      },
      {
        "<leader>mj",
        function()
          require("continuum").jumplist()
        end,
        desc = "Save session",
      },
    },
    opts = {
      custom = {
        workbuffers = function()
          return require("workbuffers.continuum")
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
