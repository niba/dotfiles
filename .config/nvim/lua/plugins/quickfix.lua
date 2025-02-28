local enabled = true
local force_trouble = false

if force_trouble then
  -- Open always in trouble
  vim.api.nvim_create_autocmd("BufRead", {
    callback = function(ev)
      if vim.bo[ev.buf].buftype == "quickfix" then
        vim.schedule(function()
          vim.cmd([[cclose]])
          vim.cmd([[Trouble qflist open]])
        end)
      end
    end,
  })
end

return {
  {
    "stevearc/quicker.nvim",
    event = "FileType qf",
    enabled = enabled,
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
    config = function(_, opts)
      require("quicker").setup({
        keys = {
          {
            ">",
            function()
              require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
            end,
            desc = "Expand quickfix context",
          },
          {
            "<",
            function()
              require("quicker").collapse()
            end,
            desc = "Collapse quickfix context",
          },
        },
      })
    end,
    keys = {},
  },
  {
    "kevinhwang91/nvim-bqf",
    enabled = enabled,
    dependencies = { "junegunn/fzf", build = vim.fn["fzf#install"] },
    event = "FileType qf",
  },
}
