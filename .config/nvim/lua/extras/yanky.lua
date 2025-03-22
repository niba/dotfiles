local M = {}

function M.smart_paste()
  local line = vim.api.nvim_get_current_line()
  if line ~= "" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(YankyPutAfterCharwise)", true, true, true), "m", true)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>(YankyPutAfter)", true, true, true), "m", true)
  end
end

return M
