local M = {}

local editor_formatters = {}
local scanned = false
local last_read

local filetype_map = {
  js = "javascript",
  jsx = "javascriptreact",
  ts = "typescript",
  tsx = "typescriptreact",
}

local filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }

M.get_editor_config_formatters = function()
  local cwd = vim.fn.getcwd()
  local settings_path = cwd .. "/.vscode/settings.json"
  local settings_stat = vim.loop.fs_stat(settings_path)

  if not settings_stat then
    return {}
  end

  local should_reload = not last_read or settings_stat.mtime.sec > last_read

  if not should_reload and scanned then
    return editor_formatters
  end

  local settings_content = vim.fn.readfile(settings_path)
  local settings_str = table.concat(settings_content, "\n")

  last_read = settings_stat.mtime.sec
  scanned = true

  local ok, settings = pcall(vim.fn.json_decode, settings_str)
  if not ok or type(settings) ~= "table" then
    editor_formatters = {}
    return editor_formatters
  end

  local global_formatter = settings["editor.defaultFormatter"]
  for _, filetype in ipairs(filetypes) do
    local filetype_settings = settings["[" .. filetype .. "]"]
    if type(filetype_settings) == "table" then
      editor_formatters[filetype] = filetype_settings["editor.defaultFormatter"] or global_formatter
    end
  end

  return editor_formatters
end

M.check_formatter = function(extension, formatter_type)
  local formatters = M.get_editor_config_formatters()
  local formatter = formatters[filetype_map[extension]]
  if not formatter then
    return nil
  end

  return formatter:lower():find(formatter_type) ~= nil
end

return M
