-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
--autosave command
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  callback = function()
    if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
      vim.api.nvim_command("silent update")
    end
  end,
})

-- restore the cursor position to the last known postiion in the file when you reopen it
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

vim.api.nvim_create_user_command("GotoPos", function(opts)
  local pos = tonumber(opts.args)
  if not pos then
    vim.notify("Please provide a position number", vim.log.levels.ERROR)
    return
  end

  -- Get current buffer content
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local text = table.concat(lines, "\n")

  -- Calculate line and column
  local current_pos = 0
  for line_num, line in ipairs(lines) do
    local line_length = #line + 1 -- +1 for newline
    if current_pos + line_length > pos then
      local col = pos - current_pos
      -- Set cursor position (line_num is 1-based, col needs to be 0-based)
      vim.api.nvim_win_set_cursor(0, { line_num, col })
      return
    end
    current_pos = current_pos + line_length
  end
end, {
  nargs = 1,
  desc = "Go to position in file",
})

-- Disable spell checking for Markdown files
vim.cmd([[
  autocmd FileType markdown setlocal nospell
]])

-- vim.api.nvim_create_autocmd("QuickFixCmdPost", {
--   callback = function()
--     vim.print("aaa")
--     vim.cmd([[Trouble qflist open]])
--   end,
-- })

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

-- https://github.com/nvim-neotest/neotest/issues/123
vim.api.nvim_create_autocmd("FileType", {
  pattern = "neotest-output-panel",
  callback = function()
    vim.cmd("norm G")
  end,
})

-- Snacks picker line highlighting doesn't work when cursorlineopt is number, this swaps the option when picker is open
local function update_cursorlineopt(value)
  local windows = vim.api.nvim_list_wins()
  for _, win_id in ipairs(windows) do
    vim.api.nvim_set_option_value("cursorlineopt", value, { win = win_id })
  end
end

vim.api.nvim_create_autocmd({ "WinNew", "BufWinEnter", "FileType" }, {
  callback = function(ev)
    local win_id = vim.api.nvim_get_current_win()
    local buf_id = vim.api.nvim_win_get_buf(win_id)
    local filetype = vim.bo[buf_id].filetype

    if filetype == "snacks_layout_box" then
      update_cursorlineopt("both")
    end
  end,
})

vim.api.nvim_create_autocmd("WinClosed", {
  callback = function(ev)
    local win_id = tonumber(ev.match)
    local buf_id = vim.api.nvim_win_get_buf(win_id)
    local filetype = vim.bo[buf_id].filetype

    if filetype == "snacks_layout_box" then
      update_cursorlineopt("number")
    end
  end,
})
