local disabled_lsp_format = {
  -- "astro",
  -- "javascript",
  -- "javascriptreact",
  -- "svelte",
  -- "typescript",
  -- "typescriptreact",
  -- "vue",
}

vim.g.lazyvim_prettier_needs_config = true

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
}
