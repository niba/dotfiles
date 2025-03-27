local M = {}

M.line_diff_in_yank = 10
M.scan_last_jumps = 8

local function smart_jumplist_back()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_pos = vim.api.nvim_win_get_cursor(0)
  -- this is a hacky way to add current position to the jumplist if we are at the top of list
  -- other solutions didn't work

  local jumplist = vim.fn.getjumplist()
  local jumps = jumplist[1]
  local current_index = jumplist[2]

  local total_jumps = #jumps

  if total_jumps < 2 then
    vim.cmd("normal! \15")
    return
  end

  local last_jump = jumps[total_jumps]
  local index_jump = jumps[current_index]

  if index_jump < (#jumps - 1) then
    vim.cmd("normal! \15")
    return
  end

  local latest_jump = jumps[total_jumps]
  local is_at_latest_jump = (
    latest_jump.bufnr == current_buf
    and latest_jump.lnum == current_pos[1]
    and latest_jump.col == current_pos[2]
  )

  if not is_at_latest_jump then
    vim.cmd("normal! \15")
    return
  end

  local start_index = math.max(1, total_jumps - M.scan_last_jumps + 1)

  local found_similar = false
  for i = total_jumps, start_index, -1 do
    local jump = jumps[i]

    if jump.bufnr == current_buf and jump.lnum == current_line and jump.col == current_col then
      found_similar = true
    end
  end
  print(string.format("last jump: %s, index jump: %s", vim.inspect(last_jump), vim.inspect(index_jump)))
  print(string.format("current index: %d, all jumpst: %d", current_index, #jumps))

  -- \6 is <c-f>
  -- vim.cmd("normal \6")
  -- local forward_pos = vim.fn.getcurpos()
  -- local at_top_of_stack = (
  --   current_pos[1] == forward_pos[1]
  --   and current_pos[2] == forward_pos[2]
  --   and current_pos[3] == forward_pos[3]
  -- )
  --
  -- if not at_top_of_stack then
  --   vim.cmd("normal! \15")
  -- end
  --
  -- if at_top_of_stack then
  --   print("adding jumplist override")
  --   vim.cmd("normal! m'")
  -- end

  vim.cmd("normal! \15")
end

local function should_add_to_jumplist()
  local current_bufnr = vim.api.nvim_get_current_buf()
  local current_line = vim.fn.line(".")
  local jumplist = vim.fn.getjumplist()
  local jumps = jumplist[1]
  local current_index = jumplist[2]

  if #jumps == 0 then
    return true
  end

  -- we need to move up index by 1
  local last_jump = jumps[current_index + 1]

  local check_proximity = function()
    local line_distance = math.abs(current_line - last_jump.lnum)
    return line_distance > M.line_diff_in_yank
  end

  if not last_jump then
    return true
  end

  if last_jump.bufnr ~= current_bufnr then
    return true
  end

  return check_proximity()
end

local function conditional_add_to_jumplist()
  if should_add_to_jumplist() then
    pcall(function()
      vim.cmd("normal! m'")
    end)
    return true
  end
  return false
end

function M.add(pos)
  if not pos then
    vim.cmd("normal! m'")
    return
  end

  local line_to_check = pos[2]
  local current_line = vim.fn.line(".")

  local line_distance = math.abs(current_line - line_to_check)
  if line_distance > M.line_diff_in_yank then
    vim.cmd("normal! m'")
  end
end

function M.create_autocmds()
  local jumplist_group = vim.api.nvim_create_augroup("YankJumplist", { clear = false })

  vim.api.nvim_create_autocmd("TextYankPost", {
    group = jumplist_group,
    callback = function()
      if vim.v.event.operator == "y" then
        print("adding jumplist conditional")
        conditional_add_to_jumplist()
      end
    end,
    desc = "Add position to jumplist after yanking based on conditions",
  })
end

function M.create_mappings()
  vim.keymap.set("n", "<C-b>", smart_jumplist_back, { desc = "Jump backward" })
  vim.keymap.set("n", "<C-f>", "<C-i>", { desc = "Jump forward" })

  -- add vertical jumps like 10k to jumplist
  vim.keymap.set("n", "j", [[(v:count > 1 ? 'm`' . v:count : 'g') . 'j']], { expr = true })
  vim.keymap.set("n", "<down>", [[(v:count > 1 ? 'm`' . v:count : 'g') . 'j']], { expr = true })
  vim.keymap.set("n", "k", [[(v:count > 1 ? 'm`' . v:count : 'g') . 'k']], { expr = true })
  vim.keymap.set("n", "<up>", [[(v:count > 1 ? 'm`' . v:count : 'g') . 'k']], { expr = true })
end

return M
