local M = {}

local call_stow = function()
  local output = vim.system({ "stow", "." }, { cwd = "/Users/niba/dotfiles/" }):wait()

  local success = output.code == 0

  if not success then
    vim.notify(string.format("Error running auto stow: %s", output.stderr), vim.log.levels.ERROR)
  end
end

local is_dotfiles_url = function(url)
  if not url then
    return false
  end

  local path = url:gsub("^oil://", "")
  return path:match("^/Users/niba/dotfiles") ~= nil
end

-- when use stow with --no-folding option then you need to sync new / deleted files
M.auto_stow = function()
  vim.api.nvim_create_autocmd("User", {
    pattern = "OilActionsPost",
    callback = function(event)
      if not (event and event.data and event.data.actions) then
        return false
      end

      local action_on_dotfiles = vim.iter(event.data.actions):any(function(action)
        if not (action.type == "create" or action.type == "remove") then
          return false
        end

        return is_dotfiles_url(action.url)
      end)

      if not action_on_dotfiles then
        return
      end

      call_stow()
    end,
  })
end

return M
