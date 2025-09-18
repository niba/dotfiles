-- vim.o.shada = ""
-- vim.o.shada = ""
vim.opt.hidden = true
vim.g.maplocalleader = ","

-- * a function with signature `function(buf) -> string|string[]`
-- vim.g.root_spec = { { ".git", "lua" }, "lsp", "cwd" }

-- obsidian required that
vim.opt.conceallevel = 1
vim.opt.swapfile = false
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.jumpoptions = "stack,view"
vim.opt.timeoutlen = 400
vim.opt.scrolloff = 12

-- vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     if client:supports_method("textDocument/foldingRange") then
--       local win = vim.api.nvim_get_current_win()
--       vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
--     end
--   end,
-- })

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

if vim.fn.has("nvim-0.12") == 1 then
  vim.opt.diffopt = {
    "internal",
    "filler",
    "closeoff",
    "context:12",
    "algorithm:myers",
    "inline:char",
    -- "followwrap",
    "indent-heuristic",
    -- Test inline:char on neovim 0.12 in the future, not fully compatible with linematch so remember to disable it???
    -- Histogram shows weird results when you reorder some lines
    -- "algorithm:histogram",
    -- dont show whitespaces diff
    "iwhite",
  }
elseif vim.fn.has("nvim-0.11") == 1 then
  vim.opt.diffopt = {
    "internal",
    "filler",
    "closeoff",
    "context:12",
    "algorithm:myers",
    "linematch:40",
    "iwhite",
    -- "followwrap",
    "indent-heuristic",
    -- Test inline:char on neovim 0.12 in the future, not fully compatible with linematch so remember to disable it???
    -- Histogram shows weird results when you reorder some lines
    -- "algorithm:histogram",
    -- dont show whitespaces diff
    -- "iwhite",
  }
end

-- vim.opt.diffopt = {
--   "internal",
--   "filler",
--   "closeoff",
--   "context:12",
--   "algorithm:myers",
--   "linematch:40",
--   -- "followwrap",
--   "indent-heuristic",
--   -- Test inline:char on neovim 0.12 in the future, not fully compatible with linematch so remember to disable it???
--   "inline:char",
--   -- Histogram shows weird results when you reorder some lines
--   -- "algorithm:histogram",
--   -- dont show whitespaces diff
--   -- "iwhite",
-- }

-- vim.o.diffopt = "internal,filler,closeoff,context:12,algorithm:histogram,linematch:40,followwrap"

vim.g.neovide_cursor_trail_size = 0
vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_cursor_animate_in_insert_mode = false
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_position_animation_length = 0
vim.g.neovide_scroll_animation_length = 0
vim.g.neovide_scroll_animation_far_lines = 0
