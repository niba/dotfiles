local M = {}

function M.reset_keymaps_before_init()
  -- We need to load these keymaps before lazy plugins
  vim.keymap.set("n", "<C-d>", "<C-d>zz", { remap = true })
  vim.keymap.set("n", "<C-u>", "<C-u>zz", { remap = true })
  -- We use r for surrounding
  vim.keymap.set("n", "r", "<Nop>")

  -- mark are not so useful
  vim.keymap.set("n", "M", "m", { silent = true, desc = "Set mark" })
  vim.keymap.set("n", "gI", "gi<ESC>zza", { silent = true, desc = "Go to last insert position" })
  vim.keymap.set("n", "gb", "gi<ESC>zza", { silent = true, desc = "Go to last insert position" })
end

function M.reset_keymaps_after_init()
  -- we don't use tabs
  vim.keymap.del("n", "<leader><tab>l")
  vim.keymap.del("n", "<leader><tab>o")
  vim.keymap.del("n", "<leader><tab>f")
  vim.keymap.del("n", "<leader><tab><tab>")
  vim.keymap.del("n", "<leader><tab>]")
  vim.keymap.del("n", "<leader><tab>d")
  vim.keymap.del("n", "<leader><tab>[")

  vim.keymap.set("x", "u", "<nop>")
  vim.keymap.set("n", "Q", "<nop>")
  vim.keymap.set("i", "<C-c>", "<esc>")
  -- we use multicursor
  vim.keymap.set("n", "q", "<Nop>", { noremap = true, silent = true })
end

return M
