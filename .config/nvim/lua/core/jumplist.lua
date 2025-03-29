local M = {}

M.line_diff_in_yank = 5
M.scan_last_jumps = 3

local function is_tail_jumplist()
  local jumps_output = vim.fn.execute("jumps")

  local lines = vim.split(jumps_output, "\n")

  return lines[#lines]:match("%s0%s") ~= nil
end

local function add_internal(position, buffer)
  local current_buf = buffer or vim.api.nvim_get_current_buf()
  local current_pos = position or vim.api.nvim_win_get_cursor(0)

  local current_line = current_pos[1]

  local jumplist = vim.fn.getjumplist()
  local jumps = jumplist[1]
  local total_jumps = #jumps

  local start_index = math.max(1, total_jumps - M.scan_last_jumps + 1)

  local found_similar = false
  for i = total_jumps, start_index, -1 do
    local jump = jumps[i]

    if found_similar then
      break
    end

    if jump.bufnr == current_buf then
      local line_distance = math.abs(current_line - jump.lnum)
      found_similar = line_distance < M.line_diff_in_yank
    end
  end

  if not found_similar then
    pcall(function()
      vim.cmd("normal! m'")
    end)
    return true
  end

  return false
end

local function smart_jumplist_back()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_pos = vim.api.nvim_win_get_cursor(0)

  local jumplist = vim.fn.getjumplist()
  local jumps = jumplist[1]
  local current_index = jumplist[2]

  local total_jumps = #jumps

  if total_jumps < 2 then
    vim.cmd("normal! \15")
    return
  end

  if not (current_index == (total_jumps - 1)) then
    -- if current_index == total_jumps then vim automatically creates restore point
    -- jumplist index works in a weird way so if we are not here then it means we can try to add mark
    vim.cmd("normal! \15")
    return
  end

  -- probably we dont need it
  -- if not is_tail_jumplist() then
  --   vim.cmd("normal! \15")
  --   return
  -- end

  add_internal(current_pos, current_buf)

  vim.cmd("normal! \15")
end

function M.add(position, buffer)
  local jumplist = vim.fn.getjumplist()
  local jumps = jumplist[1]
  local current_index = jumplist[2]
  local total_jumps = #jumps
  if current_index >= (total_jumps - 1) then
    add_internal(position, buffer)
  end
end

function M.create_autocmds()
  local jumplist_group = vim.api.nvim_create_augroup("YankJumplist", { clear = false })

  vim.api.nvim_create_autocmd("TextYankPost", {
    group = jumplist_group,
    callback = function()
      if vim.v.event.operator == "y" then
        M.add()
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
