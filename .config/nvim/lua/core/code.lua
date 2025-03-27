local M = {}

-- naive but works
function M.go_to_import_header()
  local cword = vim.fn.expand("<cword>")
  if cword ~= "" then
    vim.fn.setreg("/", "\\<" .. cword .. "\\>")
    vim.cmd([[normal! gg]])
    vim.cmd("normal! n")
    vim.cmd("noh")
  end
end

-- naive but works
function M.get_diagnostics(start_line, end_line, bufnr)
  if end_line == nil then
    end_line = start_line
  end

  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local diagnostics = {}

  for line_num = start_line, end_line do
    local line_diagnostics = vim.diagnostic.get(bufnr, {
      lnum = line_num - 1,
      severity = { min = vim.diagnostic.severity.HINT },
    })

    if next(line_diagnostics) ~= nil then
      for _, diagnostic in ipairs(line_diagnostics) do
        table.insert(diagnostics, {
          line_number = line_num,
          message = diagnostic.message,
          severity = vim.diagnostic.severity[diagnostic.severity],
        })
      end
    end
  end

  return diagnostics
end

function M.create_mappings()
  vim.keymap.set("n", "<Leader>ct", function()
    local line_num = vim.api.nvim_win_get_cursor(0)[1]
    local diagnostics = M.get_diagnostics(line_num)

    if #diagnostics == 0 then
      print("No diagnostics to copy")
      return
    end

    vim.fn.setreg("+", diagnostics[1].message)
  end, { desc = "Copy diagnostic", noremap = true, silent = true })

  vim.keymap.set("n", "gj", M.go_to_import_header, { noremap = true, silent = true, desc = "Go to import header" })
end

return M
