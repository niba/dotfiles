local M = {}

local function smart_jumplist_back()
  local current_pos = vim.fn.getcurpos()

  -- \6 is <c-f>
  vim.cmd("normal \6")
  local forward_pos = vim.fn.getcurpos()
  local at_top_of_stack = (
    current_pos[1] == forward_pos[1]
    and current_pos[2] == forward_pos[2]
    and current_pos[3] == forward_pos[3]
  )

  if not at_top_of_stack then
    vim.cmd("normal! \15")
  end

  if at_top_of_stack then
    vim.cmd("normal! m'")
  end

  vim.cmd("normal! \15")
end

local function should_add_to_jumplist()
  local current_bufnr = vim.api.nvim_get_current_buf()
  local current_line = vim.fn.line(".")
  local jumplist = vim.fn.getjumplist()
  local jumps = jumplist[1]
  local current_index = jumplist[2]

  -- If jumplist is empty, always add
  if #jumps == 0 then
    return true
  end

  -- Get the most recent jump
  local last_jump = jumps[current_index]
  if not last_jump then
    -- If we can't get the last jump, be safe and add to jumplist
    return true
  end

  -- If last jump was in a different buffer, add to jumplist
  if last_jump.bufnr ~= current_bufnr then
    return true
  end

  -- If in the same buffer, check if we've moved more than 10 lines
  local line_distance = math.abs(current_line - last_jump.lnum)
  return line_distance > 10
end

-- Function to conditionally add to jumplist
local function conditional_add_to_jumplist()
  if should_add_to_jumplist() then
    pcall(function()
      vim.cmd("normal! m'")
    end)
    return true
  end
  return false
end

function M.create_mappings()
  -- Set up autocommands for the specified operations
  local jumplist_group = vim.api.nvim_create_augroup("JumplistAdditions", { clear = true })

  -- Add to jumplist when yanking text (if condition met)
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = jumplist_group,
    callback = conditional_add_to_jumplist,
    desc = "Add position to jumplist after yanking based on conditions",
  })

  -- Add to jumplist when entering insert mode (if condition met)
  vim.api.nvim_create_autocmd("InsertEnter", {
    group = jumplist_group,
    callback = conditional_add_to_jumplist,
    desc = "Add position to jumplist when entering insert based on conditions",
  })

  vim.keymap.set("n", "<C-b>", smart_jumplist_back, { noremap = true, silent = true })
  vim.keymap.set("n", "<C-f>", "<C-i>", { silent = true, desc = "Jump forward" })

  -- add vertical jumps like 10k to jumplist
  vim.keymap.set("n", "j", [[(v:count > 1 ? 'm`' . v:count : 'g') . 'j']], { expr = true })
  vim.keymap.set("n", "<down>", [[(v:count > 1 ? 'm`' . v:count : 'g') . 'j']], { expr = true })
  vim.keymap.set("n", "k", [[(v:count > 1 ? 'm`' . v:count : 'g') . 'k']], { expr = true })
  vim.keymap.set("n", "<up>", [[(v:count > 1 ? 'm`' . v:count : 'g') . 'k']], { expr = true })
end

return M
