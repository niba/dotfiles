local M = {}

M.special_keys = {
  C_i = "<F7>",
  C_m = "<F8>",
}

M.default_actions = {
  C_d = "<C-d>zz",
  C_u = "<C-u>zz",
}

M.call_plug = function(cmd)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, false, true), "m", true)
end

return M
