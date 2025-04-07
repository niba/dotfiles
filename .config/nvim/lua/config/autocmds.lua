local core = require("core")
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

-- Disable spell checking for Markdown files
vim.cmd([[
  autocmd FileType markdown setlocal nospell
]])

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client:supports_method("textDocument/foldingRange") then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end
  end,
})

core.jumplist.create_autocmds()
core.yank.create_autocmds()

local function create_cursor_line_opt_toggle()
  local filetypes = { "snacks_picker_input", "grug-far", "trouble" }

  local function update_cursorlineopt(value)
    local windows = vim.api.nvim_list_wins()
    for _, win_id in ipairs(windows) do
      vim.api.nvim_set_option_value("cursorlineopt", value, { win = win_id })
    end
  end

  local filetypes_lookup = {}
  for _, ft in ipairs(filetypes) do
    filetypes_lookup[ft] = true
  end

  vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
    callback = function(ev)
      local buf_id = ev.buf
      local filetype = vim.bo[buf_id].filetype

      if filetypes_lookup[filetype] then
        update_cursorlineopt("both")
      end
    end,
  })

  vim.api.nvim_create_autocmd("BufLeave", {
    callback = function(ev)
      local buf_id = ev.buf
      local filetype = vim.bo[buf_id].filetype

      if filetypes_lookup[filetype] then
        update_cursorlineopt("number")
      end
    end,
  })
end

create_cursor_line_opt_toggle()
