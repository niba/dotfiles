local jumplist = require("core.jumplist")
local M = {}

M.last_yanked = nil

function M.create_autocmds()
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      if vim.v.event.operator == "y" then
        M.last_yanked = {
          buf = vim.api.nvim_get_current_buf(),
          pos = vim.fn.getpos("."),
        }
      end
    end,
  })
end

function M.go_to_last_yanked_position()
  if M.last_yanked then
    jumplist.add(M.last_yanked.pos, M.last_yanked.buf)
    if M.last_yanked.buf ~= vim.api.nvim_get_current_buf() then
      vim.api.nvim_set_current_buf(M.last_yanked.buf)
    end
    vim.fn.setpos(".", M.last_yanked.pos)
    vim.cmd("normal! zz")
  end
end

return M
