return {

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    -- REMOVE THIS once https://github.com/folke/noice.nvim/issues/921#issuecomment-2253363579
    commit = "d9328ef903168b6f52385a751eb384ae7e906c6f",
    opts = {
      routes = {
        -- REMOVE THIS once this issue is fixed: https://github.com/christoomey/vim-tmux-navigator/issues/396
        {
          filter = {
            event = "msg_show",
            find = "_TmuxAwareNavigate",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            find = 'Key not present in Dictionary: "p"',
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            find = "27:",
          },
          opts = { skip = true },
        },
        -- REMOVE THIS once this issue is fixed: https://github.com/yioneko/vtsls/issues/159
        {
          filter = {
            event = "notify",
            find = "Request textDocument/inlayHint failed",
          },
          opts = { skip = true },
        },
      },
      views = {
        hover = {
          border = { style = "rounded" },
          size = { max_width = 100 },
          position = { row = 2, col = 2 },
        },
      },
    },
    keys = {
      {
        "<C-d>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<C-d>zz"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Forward",
        mode = { "n" },
      },
      {
        "<C-u>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<C-u>zz"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Backward",
        mode = { "n" },
      },
      {
        "<C-d>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<C-d>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Forward",
        mode = { "i", "s" },
      },
      {
        "<C-u>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<C-u>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Backward",
        mode = { "i", "s" },
      },
    },
  },
}
