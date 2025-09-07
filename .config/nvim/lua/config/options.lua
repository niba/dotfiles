-- vim.o.shada = ""
-- vim.o.shada = ""
vim.opt.hidden = true
vim.g.maplocalleader = ","

-- * a function with signature `function(buf) -> string|string[]`
-- vim.g.root_spec = { { ".git", "lua" }, "lsp", "cwd" }

-- obsidian required that
vim.opt.conceallevel = 1

vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.jumpoptions = "stack,view"
vim.opt.timeoutlen = 400
vim.opt.scrolloff = 12

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

vim.opt.diffopt = {
  "internal",
  "filler",
  "closeoff",
  "context:12",
  "algorithm:histogram",
  "linematch:40",
  "followwrap",
  "indent-heuristic",
  -- "iwhite",
}

vim.g.neovide_cursor_trail_size = 0
vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_cursor_animate_in_insert_mode = false
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_position_animation_length = 0
vim.g.neovide_scroll_animation_length = 0
vim.g.neovide_scroll_animation_far_lines = 0
