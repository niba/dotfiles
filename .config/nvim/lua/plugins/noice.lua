return {
  {
    "folke/noice.nvim",
    enabled = true,
    -- VeryLazy causes rendering issues like empty blank linke on the bottom of code
    event = "BufEnter",
    opts = {
      presets = {
        lsp_doc_border = true,
      },
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
        -- {
        --   filter = {
        --     event = "msg_show",
        --     find = "27:",
        --   },
        --   opts = { skip = true },
        -- },
        -- REMOVE THIS once this issue is fixed: https://github.com/yioneko/vtsls/issues/159
        {
          filter = {
            event = "notify",
            find = "Request textDocument/inlayHint failed",
          },
          opts = { skip = true },
        },
      },
    },
    keys = {
      {
        "<C-d>",
        function()
          if not require("noice.lsp").scroll(4) then
            return Utils.default_actions.C_d
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
            return Utils.default_actions.C_u
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
