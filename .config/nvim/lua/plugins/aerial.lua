return {
  {
    "stevearc/aerial.nvim",
    opts = {
      filter_kind = false,
      backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },
      autojump = true,
      highlight_on_hover = true,
      nav = {
        autojump = true,
      },
    },
    keys = {
      {
        "<leader>cz",
        function()
          require("aerial").snacks_picker({
            layout = { preset = "sidebar", preview = "main", layout = { position = "right" } },
          })
        end,
        desc = "LSP Symbols",
      },
    },
  },
}
