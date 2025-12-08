_G.Utils = require("utils")

if vim.env.VSCODE then
  vim.g.vscode = true
end

_G.dd = function(...)
  require("snacks.debug").inspect(...)
end

require("core.reset").reset_keymaps_before_init()

vim.g.bullets_enable_in_empty_buffers = 0

require("config.lazy")

vim.lsp.enable("tsgo")
