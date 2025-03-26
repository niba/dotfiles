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
  },
}
