local formatters_extra = require("extras.format")

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

local dprint_supported = {
  "typescript",
  "javascript",
}

return {
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "eslint_d" } },
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}

      for _, ft in ipairs(dprint_supported) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        -- we use dprint through eslint
        table.insert(opts.formatters_by_ft[ft], "eslint_d")
      end

      for _, ft in ipairs(disabled_lsp_format) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        opts.formatters_by_ft[ft].lsp_format = "never"
      end
      opts.formatters = opts.formatters or {}
      opts.formatters.eslint_d = {
        require_cwd = true,
        condition = function(_, ctx)
          local ext = vim.fn.fnamemodify(ctx.filename, ":e")
          if ext == "" then
            return false
          end

          return formatters_extra.check_formatter(ext, "eslint")
        end,
      }

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
