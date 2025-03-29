local M = {}

local function close_other_windows()
  local current_win = vim.api.nvim_get_current_win()
  for _, win in pairs(vim.api.nvim_list_wins()) do
    if win ~= current_win then
      vim.api.nvim_win_close(win, false)
    end
  end
end

function M.create_mappings()
  vim.keymap.set("n", "<C-x>", "<cmd>close<CR>", { noremap = true, silent = true, desc = "Close current window" })
  vim.keymap.set("n", "<leader>wp", "<C-W>p", { desc = "Other window", remap = true })
  vim.keymap.set("n", "<leader>wh", "<C-W>s", { desc = "Split window horizontaly", remap = true })
  vim.keymap.set("n", "<leader>ws", "<C-W>v", { desc = "Split window horizontaly", remap = true })
  vim.keymap.set("n", "<leader>wv", "<C-W>v", { desc = "Split window verticaly", remap = true })
  vim.keymap.set("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" })
  vim.keymap.set("n", "<leader>wt", function()
    close_other_windows()
  end, { desc = "Close other windows", remap = true, silent = true })
  vim.keymap.set("n", "<leader>wp", function()
    local window = Snacks.picker.util.pick_win()
    if window ~= nil then
      vim.api.nvim_set_current_win(window)
    end
  end, { desc = "Pick window", silent = true })
end

return M
