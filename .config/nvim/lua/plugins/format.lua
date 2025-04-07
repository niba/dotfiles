local disabled_lsp_format = {
  -- "astro",
  -- "javascript",
  -- "javascriptreact",
  -- "svelte",
  -- "typescript",
  -- "typescriptreact",
  -- "vue",
}

-- vim.g.lazyvim_prettier_needs_config = true

return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(disabled_lsp_format) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        opts.formatters_by_ft[ft].lsp_format = "never"
      end
      return opts
    end,
  },
  {
    "Wansmer/treesj",
    enabled = true,
    keys = {
      {
        "<leader>cj",
        function()
          require("treesj").toggle()
        end,
        desc = "Mark file",
      },
    },
    opts = {
      use_default_keymaps = false,
      max_join_length = 80,
      check_syntax_error = false,
    },
    config = function(_, opts)
      require("treesj").setup(opts)
    end,
  },
}
