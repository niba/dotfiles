return {
  {
    "bloznelis/before.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },

    keys = function()
      local before = require("before")
      return {
        {
          "<leader>se",
          function()
            before.show_edits_in_telescope()
          end,
          desc = "Search edit history",
        },
        {
          "<C-S-b>",
          function()
            before.jump_to_last_edit()
          end,
          desc = "Go to previous edit",
        },
        {
          "<C-S-f>",
          function()
            before.jump_to_next_edit()
          end,
          desc = "Go to next edit",
        },
      }
    end,

    config = function()
      local before = require("before")
      before.setup()
    end,
  },
}
