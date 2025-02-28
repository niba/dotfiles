-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
--
-- vim.o.shada = ""
-- vim.o.shada = ""
vim.opt.hidden = true
vim.g.maplocalleader = ","

vim.g.material_style = "palenight"
-- * a function with signature `function(buf) -> string|string[]`
-- vim.g.root_spec = { { ".git", "lua" }, "lsp", "cwd" }

-- obsidian required that
vim.opt.conceallevel = 1

vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.jumpoptions = "stack,view"
vim.opt.timeoutlen = 400

vim.diagnostic.config({
  float = { border = "rounded" },
})

vim.g.rustaceanvim = {
  tools = {
    hover_actions = {
      replace_builtin_hover = false,
    },
    float_win_config = {
      border = "rounded",
      max_height = 70,
    },
  },
}
