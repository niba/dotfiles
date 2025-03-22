local M = {}

M.autocmds = function()
  vim.api.nvim_create_autocmd("User", {
    pattern = "OilActionsPre",
    callback = function(args)
      vim.print(args)
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "OilActionsPost",
    callback = function(args)
      -- If err is non-null, we encountered an error while processing the actions
      if args.data.err then
        vim.print("ERROR", args.data.err)
      else
        vim.print(args)
      end
    end,
  })
end

return M
