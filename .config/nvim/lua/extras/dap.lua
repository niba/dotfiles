local M = {}

function M.create_autocmds()
  -- Set up autocmd group for dap-float windows
  local dap_float_group = vim.api.nvim_create_augroup("DapFloatGroup", { clear = true })

  -- FileType autocmd for 'q' keymap
  vim.api.nvim_create_autocmd("FileType", {
    group = dap_float_group,
    pattern = "dap-float",
    callback = function()
      vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close!<CR>", { noremap = true, silent = true })
    end,
  })

  -- BufLeave autocmd for autoclose
  vim.api.nvim_create_autocmd("BufLeave", {
    group = dap_float_group,
    pattern = "dap-float",
    callback = function()
      vim.schedule(function()
        local win = vim.fn.win_getid()
        if vim.api.nvim_win_get_config(win).relative ~= "" then
          vim.api.nvim_win_close(win, false)
        end
      end)
    end,
  })
end

return M
