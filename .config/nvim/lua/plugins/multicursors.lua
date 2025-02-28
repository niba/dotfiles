return {
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    -- event = "BufEnter",
    keys = {
      {
        "<esc>",
        function()
          local mc = require("multicursor-nvim")
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          elseif mc.hasCursors() then
            mc.clearCursors()
          else
            return "<cmd>noh<cr><esc>"
          end
        end,
        mode = { "n" },
        desc = "Clear multicursors",
        expr = true,
      },
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
        "<c-s-up>",
        function()
          local mc = require("multicursor-nvim")
          mc.lineSkipCursor(-1)
        end,
        mode = { "n", "v" },
        desc = "Skip multicursor up",
      },
      {
        "<c-s-down>",
        function()
          local mc = require("multicursor-nvim")
          mc.lineSkipCursor(1)
        end,
        mode = { "n", "v" },
        desc = "Skip multicursor down",
      },
      {
        "<F7>",
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
      --
      -- vim.print("setup multicursor")
      mc.setup()
      --
      -- -- Add cursors above/below the main cursor.
      -- vim.keymap.set({ "n", "v" }, "<S-Up>", function()
      --   mc.addCursor("k")
      -- end)
      -- vim.keymap.set({ "n", "v" }, "<S-Down>", function()
      --   mc.addCursor("j")
      -- end)
      --
      -- -- Add a cursor and jump to the next word under cursor.
      -- vim.keymap.set({ "n", "v" }, "<F7>", function()
      --   mc.addCursor("*")
      -- end)

      -- -- Jump to the next word under cursor but do not add a cursor.
      -- vim.keymap.set({ "n", "v" }, "<c-s>", function()
      --   mc.skipCursor("*")
      -- end)
      --
      -- -- Rotate the main cursor.
      -- vim.keymap.set({ "n", "v" }, "<left>", mc.nextCursor)
      -- vim.keymap.set({ "n", "v" }, "<right>", mc.prevCursor)
      --
      -- -- Delete the main cursor.
      -- vim.keymap.set({ "n", "v" }, "<leader>x", mc.deleteCursor)
      --
      -- -- Add and remove cursors with control + left click.
      -- vim.keymap.set("n", "<c-leftmouse>", mc.handleMouse)
      --
      -- vim.keymap.set({ "n", "v" }, "<c-q>", function()
      --   if mc.cursorsEnabled() then
      --     -- Stop other cursors from moving.
      --     -- This allows you to reposition the main cursor.
      --     mc.disableCursors()
      --   else
      --     mc.addCursor()
      --   end
      -- end)
      --
      -- vim.keymap.set("n", "<esc>", function()
      --   vim.print("IN MULTICURSOR")
      --   if not mc.cursorsEnabled() then
      --     mc.enableCursors()
      --   elseif mc.hasCursors() then
      --     mc.clearCursors()
      --   else
      --     return "<esc>"
      --     -- Default <esc> handler.
      --   end
      -- end, { expr = true, remap = true })

      -- vim.keymap.set("n", "<c-q>", function()
      --   if not mc.cursorsEnabled() then
      --     mc.enableCursors()
      --   elseif mc.hasCursors() then
      --     mc.clearCursors()
      --   else
      --     -- Default <esc> handler.
      --   end
      -- end)
      -- Align cursor columns.
      -- vim.keymap.set("n", "<leader>a", mc.alignCursors)
      --
      -- -- Split visual selections by regex.
      -- vim.keymap.set("v", "S", mc.splitCursors)
      --
      -- -- Append/insert for each line of visual selections.
      -- vim.keymap.set("v", "I", mc.insertVisual)
      -- vim.keymap.set("v", "A", mc.appendVisual)
      --
      -- -- match new cursors within visual selections by regex.
      -- vim.keymap.set("v", "M", mc.matchCursors)
      --
      -- -- Rotate visual selection contents.
      -- vim.keymap.set("v", "<leader>t", function()
      --   mc.transposeCursors(1)
      -- end)
      -- vim.keymap.set("v", "<leader>T", function()
      --   mc.transposeCursors(-1)
      -- end)

      -- Customize how cursors look.
      vim.api.nvim_set_hl(0, "MultiCursorCursor", { link = "Cursor" })
      vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
      vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
      vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    end,
  },
  {
    "mg979/vim-visual-multi",
    -- lazy = false,
    enabled = false,
    opts = function()
      vim.cmd("hi! VM_Mono guibg=Grey60 guifg=Black gui=NONE")
    end,
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<F7>", -- it is "<C-m>",
        ["Find Subword Under"] = "<F7>", -- it is "<C-m>",
        ["Add Cursor Down"] = "<S-Down>",
        ["Add Cursor Up"] = "<S-Up>",
        ["Add Cursor At Pos"] = "<S-Right>",
        -- ["Switch Mode"] = "<S-Left>",
      }
    end,
  },
}
