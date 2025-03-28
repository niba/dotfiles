local function smart_paste()
  local line = vim.api.nvim_get_current_line()
  if line ~= "" then
    Utils.call_plug("<Plug>(YankyPutAfterCharwise)")
  else
    Utils.call_plug("<Plug>(YankyPutAfter)")
  end
end

local function smart_visual_paste()
  -- we use YankyPutBefore in visual because it preserves yanked text on deletion
  if vim.fn.mode() == "V" then
    Utils.call_plug("<Plug>(YankyPutBefore)")
  else
    Utils.call_plug("<Plug>(YankyPutBeforeCharwise)")
  end
end

return {
  {
    "gbprod/yanky.nvim",
    dependencies = {
      { "kkharji/sqlite.lua" },
    },
    opts = function()
      return {
        highlight = { on_put = true, on_yank = true, timer = 200 },
        ring = {
          history_length = 50,
        },
      }
    end,
    keys = {
      {
        "<leader>sp",
        function()
          Snacks.picker.yanky()
        end,
        desc = "Open Yank History",
      },
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
      { "p", smart_paste, mode = { "n" }, desc = "Put yanked text after cursor" },
      { "p", smart_visual_paste, mode = { "x" }, desc = "Put yanked text after cursor" },
      { "P", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
      { "<C-S-p>", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle forward through yank history" },
      { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle backward through yank history" },
    },
  },
}
