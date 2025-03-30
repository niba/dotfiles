local M = {}

function M.inactive_diff()
  local dv = require("diffview.lib")

  local tabs = vim.api.nvim_list_tabpages()

  for _, tabpage in ipairs(tabs) do
    for _, view in ipairs(dv.views) do
      if view.tabpage == tabpage then
        return tabpage
      end
    end
  end

  return nil
end

function M.toggle_diff()
  local dv = require("diffview.lib")

  local current_diff = dv.get_current_view()

  if current_diff ~= nil then
    vim.cmd("DiffviewClose")
  else
    local inactive_diff_tab = M.inactive_diff()

    if inactive_diff_tab ~= nil then
      vim.api.nvim_set_current_tabpage(inactive_diff_tab)
    else
      vim.cmd("DiffviewOpen")
    end
  end
end

return M
