local function smart_paste()
  local line = vim.api.nvim_get_current_line()
  if line ~= "" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(YankyPutAfterCharwise)", true, true, true), "m", true)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(YankyPutAfter)", true, true, true), "m", true)
  end
end

local function smart_visual_paste()
  -- we use YankyPutBefore in visual because it preserves yanked text on deletion
  if vim.fn.mode() == "V" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(YankyPutBefore)", true, true, true), "m", true)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(YankyPutBeforeCharwise)", true, true, true), "m", true)
  end
end

return {
  {
    "gbprod/yanky.nvim",
    dependencies = {
      { "kkharji/sqlite.lua" },
    },
    opts = function()
      local mapping = require("yanky.telescope.mapping")
      local mappings = mapping.get_defaults()
      mappings.i["<c-p>"] = nil
      return {
        highlight = { on_put = true, on_yank = true, timer = 200 },
        ring = { storage = "sqlite" },
        picker = {
          telescope = {
            use_default_mappings = false,
            mappings = mappings,
          },
        },
      }
    end,
    keys = {
      {
        "<leader>sp",
        function()
          if LazyVim.pick.picker.name == "telescope" then
            require("telescope").extensions.yank_history.yank_history({})
          else
            vim.cmd([[YankyRingHistory]])
          end
        end,
        desc = "Open Yank History",
      },
      -- core
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },

      { "p", smart_paste, mode = { "n" }, desc = "Put yanked text after cursor" },
      { "p", smart_visual_paste, mode = { "x" }, desc = "Put yanked text after cursor" },
      -- { "p", "<Plug>(YankyPutBefore)", mode = { "V" }, desc = "Put yanked text after cursor" },

      { "P", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },

      -- other
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after selection" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before selection" },
      { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle forward through yank history" },
      { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle backward through yank history" },
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
      { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and indent right" },
      { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and indent left" },
      { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
      { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put before and indent left" },
      { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
      { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
    },
  },
}
