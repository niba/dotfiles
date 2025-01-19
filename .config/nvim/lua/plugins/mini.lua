return {
  {
    "echasnovski/mini.move",
    event = "VeryLazy",
    keys = {
      { "<M-left>", [[<Cmd>lua MiniMove.move_selection('left')<CR>]], mode = { "x" }, desc = "Move left" },
      { "<M-right>", [[<Cmd>lua MiniMove.move_selection('right')<CR>]], mode = { "x" }, desc = "Move right" },
      { "<M-down>", [[<Cmd>lua MiniMove.move_selection('down')<CR>]], mode = { "x" }, desc = "Move down" },
      { "<M-up>", [[<Cmd>lua MiniMove.move_selection('up')<CR>]], mode = { "x" }, desc = "Move up" },
    },
  },
  { "echasnovski/mini.test", version = false },
}
