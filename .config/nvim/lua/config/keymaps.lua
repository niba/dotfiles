-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

--
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--                        IMPORTANT
--
-- Vim doesn't differentiate <C-I> from <Tab> and <C-M> from <CR>.
-- To have custom bindings for <C-I> and <C-M> we map them to F8 and F7
-- F8 means <C-I>
-- F7 means <C-M>
--
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--
-- we don't use tabs
vim.keymap.del("n", "<leader><tab>l")
vim.keymap.del("n", "<leader><tab>o")
vim.keymap.del("n", "<leader><tab>f")
vim.keymap.del("n", "<leader><tab><tab>")
vim.keymap.del("n", "<leader><tab>]")
vim.keymap.del("n", "<leader><tab>d")
vim.keymap.del("n", "<leader><tab>[")

vim.keymap.set({ "n", "i" }, "<C-Tab>", "<cmd>e #<cr>", { desc = "Jump to previous buffer" })
-- Bind Shift+Ctrl+U to scroll one line up
vim.api.nvim_set_keymap("n", "<S-C-u>", "<C-y>", { noremap = true, silent = true })
-- Bind Shift+Ctrl+D to scroll one line down
vim.api.nvim_set_keymap("n", "<S-C-d>", "<C-e>", { noremap = true, silent = true })

-- Custom jumplist keys
-- Pane / tmux navigation takes c-o and c-i (F8)
-- vim.api.nvim_set_keymap("n", "<C-b>", "<C-o>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<C-f>", "F8", { noremap = true, silent = true })
vim.keymap.set("n", "<C-b>", "<C-o>", { silent = true, desc = "Jump backward" })
vim.keymap.set("n", "<C-f>", "<C-i>", { silent = true, desc = "Jump forward" })
-- add vertical jumps like 10k to jumplist
vim.keymap.set("n", "j", [[(v:count > 1 ? 'm`' . v:count : 'g') . 'j']], { expr = true })
vim.keymap.set("n", "<down>", [[(v:count > 1 ? 'm`' . v:count : 'g') . 'j']], { expr = true })
vim.keymap.set("n", "k", [[(v:count > 1 ? 'm`' . v:count : 'g') . 'k']], { expr = true })
vim.keymap.set("n", "<up>", [[(v:count > 1 ? 'm`' . v:count : 'g') . 'k']], { expr = true })

vim.keymap.set("n", "<M-h>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<M-H>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<M-W>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<M-w>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
-- fix paste
-- vim.keymap.set("x", "p", "P") <- handled by yanky plugin, it is better to do _dp because P replaces under cursor and not after cursor like p
vim.keymap.set({ "n", "x" }, "<leader>p", [["0p]], { desc = "Paste from yank register" })
local function do_action_and_join_registers(action)
  local register = "*" -- yank plugin uses *
  local current_content = vim.fn.getreg(register)
  vim.api.nvim_command("normal! " .. action)
  local new_content = vim.fn.getreg(register)
  vim.fn.setreg(register, current_content .. new_content)
end
local function delete_and_append()
  do_action_and_join_registers("d")
end

local function yank_and_append()
  do_action_and_join_registers("y")
end
vim.keymap.set({ "x" }, "<leader>d", delete_and_append, { desc = "Delete and append to register" })
vim.keymap.set({ "x" }, "<leader>y", yank_and_append, { desc = "Yank and append to register" })

vim.keymap.set("x", "u", "<nop>")
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("i", "<C-c>", "<esc>")

vim.keymap.set({ "n", "s" }, "<C-c>", function()
  vim.cmd("noh")
  LazyVim.cmp.actions.snippet_stop()
  return "<C-c>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- breaks navigation in cmp
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "gh", function()
  vim.fn.setreg("/", "\\<" .. vim.fn.expand("<cword>") .. "\\>")
  vim.cmd([[normal! gg]])
  vim.cmd("normal! n")
  vim.cmd("noh")
end, { noremap = true, silent = true, desc = "Go to import header" })

vim.keymap.set(
  "n",
  "<Leader>bl",
  ':echo fnamemodify(expand("%:h"), ":~:.") . "/" . expand("%:t")<CR>',
  { noremap = true, silent = true, desc = "Show file location" }
)
vim.keymap.set(
  "n",
  "<Leader>bL",
  ':redir @+ | echo fnamemodify(expand("%:h"), ":~:.") . "/" . expand("%:t") | redir END<CR>',
  { noremap = true, silent = true, desc = "Show and copy file location" }
)

vim.keymap.set("n", "<leader>R", function()
  local word = vim.fn.expand("<cword>")
  vim.api.nvim_input(":<C-u>%s/\\v(" .. word .. ")/" .. word .. "/gI<Left><Left><Left>")
end, { desc = "Replace word under cursor" })
vim.keymap.set("x", "<leader>R", function()
  vim.api.nvim_input(":s/\\%V//gI<Left><Left><Left><Left>")
end, { desc = "Search and replace in selection" })
vim.keymap.set("x", "<leader>r", function()
  vim.cmd('normal! "vy')
  local yanked_text = vim.fn.getreg("v")
  yanked_text = yanked_text:gsub("\n", "")
  yanked_text = yanked_text:match("^%s*(.-)%s*$")
  yanked_text = vim.fn.escape(yanked_text, "/\\^$.*+?()[]{}|")

  vim.api.nvim_input(":<C-u>" .. "%s/\\v(" .. yanked_text .. ")/" .. yanked_text .. "/gI<Left><Left><Left>")
end, { desc = "Replace selected text", noremap = true, silent = true })

vim.keymap.set("n", "i", function()
  if #vim.fn.getline(".") == 0 then
    return [["_cc]]
  else
    return "i"
  end
end, { expr = true, desc = "Properly indent on empty line when insert" })

vim.keymap.set("n", "<leader>wp", "<C-W>p", { desc = "Other window", remap = true })
vim.keymap.set("n", "<leader>wh", "<C-W>s", { desc = "Split window horizontaly", remap = true })
vim.keymap.set("n", "<leader>wv", "<C-W>v", { desc = "Split window verticaly", remap = true })
vim.keymap.set("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set(
  "n",
  "<leader>wt",
  ":lua CloseOtherWindows()<CR>",
  { desc = "Close other windows", remap = true, silent = true }
)

function CloseOtherWindows()
  local current_win = vim.api.nvim_get_current_win()
  for _, win in pairs(vim.api.nvim_list_wins()) do
    if win ~= current_win then
      vim.api.nvim_win_close(win, false)
    end
  end
end

function CopyDiagnosticToClipboard()
  local line_num = vim.api.nvim_win_get_cursor(0)[1] - 1 -- Get current line number, 0-indexed
  local diagnostics = vim.diagnostic.get(0, { lnum = line_num }) -- Get diagnostics for the current line

  if #diagnostics == 0 then
    print("No diagnostics to copy")
    return
  end

  local diagnostic_message = diagnostics[1].message -- Get the first diagnostic message
  print("diagnostic copied: " .. diagnostic_message) -- optional: print the diagnostic message

  -- Copy the diagnostic message to the '+' register (system clipboard)
  vim.fn.setreg("+", diagnostic_message)
end
vim.api.nvim_set_keymap(
  "n",
  "<Leader>cD",
  ":lua CopyDiagnosticToClipboard()<CR>",
  { desc = "Copy diagnostic", noremap = true, silent = true }
)

vim.keymap.set("n", "<C-q>", function()
  -- Check if we're in tmux
  local in_tmux = os.getenv("TMUX") ~= nil

  if in_tmux then
    -- Get current tmux session name
    local current_session = vim.fn.system("tmux display-message -p '#S'"):gsub("\n", "")

    -- Get only the part before whitespace
    local session_prefix = current_session:match("^(%S+)")

    -- Check if we're in dotfiles session (ignoring any numbers after)
    if session_prefix == "dotfiles" or session_prefix == "notes" or session_prefix == "NVIM_POPUP" then
      vim.fn.system("tmux detach-client")
    else
      -- Optional: Print message if not in dotfiles session
      print("Not in dotfiles session")
    end
  end
end, { desc = "Detach from dotfiles tmux session" })

-- TESTING AREA
-- Window movement

-- local function new_horizontal_window()
--   vim.cmd("new")
-- end
--
-- local function new_vertical_window()
--   vim.cmd("vnew")
-- end
--
-- local function move_to_window(direction)
--   local key_map = {
--     h = "<Left>",
--     j = "<Down>",
--     k = "<Up>",
--     l = "<Right>",
--   }
--   vim.cmd("wincmd " .. key_map[direction])
-- end

-- space+w + hjkl => resize
-- ctrl+w other window
-- space + w + = => equal dimensions
-- split window
-- quit window
-- close others
