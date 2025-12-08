local core = require("core")

require("core.reset").reset_keymaps_after_init()
core.tmux.create_mappings()
core.windows.create_mappings()
core.code.create_mappings()
core.jumplist.create_mappings()

vim.keymap.set({ "n", "i" }, "<C-Tab>", "<cmd>e #<cr>", { desc = "Jump to previous buffer" })
vim.api.nvim_set_keymap("n", "<S-C-u>", "<C-y>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-C-d>", "<C-e>", { noremap = true, silent = true })

vim.keymap.set({ "n", "x" }, "<leader>p", [["0p]], { desc = "Paste from yank register" })

-- TODO: conflict with dap in select mode
vim.keymap.set({ "x" }, "<leader>d", function()
  core.registers.do_action_and_join_registers("d")
end, { desc = "Delete and append to register" })
vim.keymap.set({ "x" }, "<leader>y", function()
  core.registers.do_action_and_join_registers("y")
end, { desc = "Yank and append to register" })

vim.keymap.set({ "n", "s" }, "<C-c>", function()
  vim.cmd("noh")
  LazyVim.cmp.actions.snippet_stop()
  return "<C-c>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

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

vim.keymap.set("n", "gy", function()
  core.yank.go_to_last_yanked_position()
end, { noremap = true, desc = "Jump to last yanked text" })

vim.keymap.set("n", "i", function()
  if #vim.fn.getline(".") == 0 then
    return [["_cc]]
  else
    return "i"
  end
end, { expr = true, desc = "Properly indent on empty line when insert" })

vim.keymap.set("n", "<c-/>", function()
  Snacks.terminal()
end, { desc = "Terminal" })
-- tmux handles c-/ as c-_
vim.keymap.set("n", "<c-_>", function()
  Snacks.terminal()
end, { desc = "which_key_ignore" })

vim.keymap.set("n", "<leader>cP", function()
  local plugins = require("lazy").plugins()
  local plugin_names = {}
  for _, plugin in ipairs(plugins) do
    table.insert(plugin_names, plugin.name)
  end

  vim.ui.select(plugin_names, {
    title = "Reload plugin",
  }, function(selected)
    require("lazy").reload({ plugins = { selected } })
  end)
end, { desc = "Reload plugin" })

vim.keymap.set("n", "gsd", core.code.split_go_to_defintion, {
  desc = "[Split] Go to definition",
})
