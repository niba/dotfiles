local M = {}

function M.do_action_and_join_registers(action)
  local register = "*"
  local current_content = vim.fn.getreg(register)
  vim.api.nvim_command("normal! " .. action)
  local new_content = vim.fn.getreg(register)
  vim.fn.setreg(register, current_content .. new_content)
end

return M
