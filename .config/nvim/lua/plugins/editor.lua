return {
  {
    {
      "echasnovski/mini.move",
      event = "VeryLazy",
      keys = {
        {
          "<M-left>",
          [[<Cmd>lua MiniMove.move_selection('left')<CR>]],
          mode = { "x" },
          desc = "Move selected left",
        },
        {
          "<M-right>",
          [[<Cmd>lua MiniMove.move_selection('right')<CR>]],
          mode = { "x" },
          desc = "Move selected right",
        },
        {
          "<M-down>",
          [[<Cmd>lua MiniMove.move_selection('down')<CR>]],
          mode = { "x" },
          desc = "Move selected down",
        },
        {
          "<M-up>",
          [[<Cmd>lua MiniMove.move_selection('up')<CR>]],
          mode = { "x" },
          desc = "Move selected up",
        },
        {
          "<M-left>",
          [[<Cmd>lua MiniMove.move_line('left')<CR>]],
          mode = { "n" },
          desc = "Move line left",
        },
        {
          "<M-right>",
          [[<Cmd>lua MiniMove.move_line('right')<CR>]],
          mode = { "n" },
          desc = "Move line right",
        },
        {
          "<M-down>",
          [[<Cmd>lua MiniMove.move_line('down')<CR>]],
          mode = { "n" },
          desc = "Move line down",
        },
        {
          "<M-up>",
          [[<Cmd>lua MiniMove.move_line('up')<CR>]],
          mode = { "n" },
          desc = "Move line up",
        },
      },
    },
  },
}
