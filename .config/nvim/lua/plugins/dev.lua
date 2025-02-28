local function testing()
  local cwd = vim.fn.getcwd()

  return string.find(cwd, "Projects/plugin_testing", 1, true) ~= nil
end

return {
  {
    "continuum",
    -- enabled = testing,
    dev = true,
    lazy = false,
    config = true,
    keys = {
      {
        "<leader>ml",
        function()
          require("continuum").list()
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
    "rmagatti/auto-session",
    lazy = true,
    enabled = false,
  },
}
