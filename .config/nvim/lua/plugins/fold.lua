local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (" 󰁂 %d "):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "MoreMsg" })
  return newVirtText
end

return {
  {
    {
      "kevinhwang91/nvim-ufo",
      enabled = true,
      dependencies = { "kevinhwang91/promise-async" },
      opts = {
        fold_virt_text_handler = handler,
        close_fold_kinds_for_ft = {
          default = { "imports", "comment" },
          json = { "array" },
        },
      },
    },
  },
  {
    "dmtrKovalenko/fold-imports.nvim",
    enabled = false,
    -- dependencies = { "chrisgrieser/nvim-origami" },
    opts = {
      custom_fold_text = false,
      fold_level = 99,
    },
    -- lazy = true,
    event = "BufRead",
  },
  {
    "chrisgrieser/nvim-origami",
    enabled = false,
    lazy = false,
    -- event = "VeryLazy",
    opts = {
      autoFold = {
        enabled = false,
      },
    }, -- needed even when using default config

    -- -- recommended: disable vim's auto-folding
    config = function(_, opts)
      require("origami").setup(opts)
      vim.api.nvim_clear_autocmds({ group = "origami.foldexpr" })
    end,
  },
}
