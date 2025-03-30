return {
  {
    "jake-stewart/multicursor.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<s-up>",
        function()
          local mc = require("multicursor-nvim")
          mc.lineAddCursor(-1)
        end,
        mode = { "n", "v" },
        desc = "Add multicursor up",
      },
      {
        "<s-down>",
        function()
          local mc = require("multicursor-nvim")
          mc.lineAddCursor(1)
        end,
        mode = { "n", "v" },
        desc = "Add multicursor down",
      },
      {
        "<s-left>",
        function()
          local mc = require("multicursor-nvim")
          mc.lineSkipCursor(-1)
        end,
        mode = { "n", "v" },
        desc = "Skip multicursor up",
      },
      {
        "<s-right>",
        function()
          local mc = require("multicursor-nvim")
          mc.lineSkipCursor(1)
        end,
        mode = { "n", "v" },
        desc = "Skip multicursor down",
      },
      {
        "<leader>mr",
        function()
          local mc = require("multicursor-nvim")
          mc.lineSkipCursor(1)
        end,
        mode = { "n" },
        desc = "Restore multicursors",
      },
      {
        "m",
        function()
          local mc = require("multicursor-nvim")
          mc.matchCursors()
        end,
        mode = { "x" },
        desc = "Match multicursors",
      },
      {
        Utils.special_keys.C_m,
        function()
          local mc = require("multicursor-nvim")
          mc.addCursor("*")
        end,
        mode = { "n", "v" },
        desc = "Add next word multicursor",
      },
    },
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      mc.addKeymapLayer(function(layerSet)
        layerSet({ "n", "x" }, "<localleader>p", mc.prevCursor)
        layerSet({ "n", "x" }, "<localleader>n", mc.nextCursor)

        layerSet({ "n", "x" }, "<localleader>a", mc.alignCursors)

        layerSet({ "n", "x" }, "<localleader>f", mc.firstCursor)
        layerSet({ "n", "x" }, "<localleader>l", mc.lastCursor)

        layerSet({ "n", "x" }, "<c-b>", mc.jumpBackward)
        layerSet({ "n", "x" }, "<c-f>", mc.jumpForward)

        layerSet({ "n", "x" }, "<localleader>mn", function()
          mc.matchAddCursor(1)
        end)
        layerSet({ "n", "x" }, "<localleader>mp", function()
          mc.matchAddCursor(-1)
        end)

        layerSet({ "n", "x" }, "<cr>", mc.toggleCursor)
        layerSet({ "n", "x" }, "<localleader>x", mc.deleteCursor)
        layerSet({ "n", "x" }, "<localleader>e", mc.enableCursors)

        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)

      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { link = "Cursor" })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },
}
