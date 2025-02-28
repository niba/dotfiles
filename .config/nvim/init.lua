if vim.env.VSCODE then
  vim.g.vscode = true
end

_G.dd = function(...)
  require("snacks.debug").inspect(...)
end
-- bootstrap lazy.nvim, LazyVim and your plugins
-- require("core.sessions")

-- We need to load these keymaps before lazy plugins
vim.keymap.set("n", "<C-d>", "<C-d>zz", { remap = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { remap = true })
-- We use r for surrounding
vim.keymap.set("n", "r", "<Nop>")

-- mark are not so useful
vim.keymap.set("n", "M", "m", { silent = true, desc = "Set mark" })
vim.keymap.set("n", "gI", "gi<ESC>zza", { silent = true, desc = "Go to last insert position" })
vim.keymap.set("n", "gb", "gi<ESC>zza", { silent = true, desc = "Go to last insert position" })

vim.g.bullets_enable_in_empty_buffers = 0

require("config.lazy")
vim.treesitter.language.register("markdown", "octo")
